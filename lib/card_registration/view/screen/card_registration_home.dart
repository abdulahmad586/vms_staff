import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/card_registration/card_registration.dart';
import 'package:shevarms_user/shared/shared.dart';

class CardRegistrationHome extends KFDrawerContent {
  @override
  State<CardRegistrationHome> createState() => _CardRegistrationHomeState();
}

class _CardRegistrationHomeState extends State<CardRegistrationHome> {
  RefreshController refreshController = RefreshController();
  BuildContext? cubitContext;

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<bool> exportToFile() async {
    Directory directory;
    try {
      String content =
          jsonEncode(CardsStorage().getCards().map((e) => e.toMap()).toList());
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          final dir = await getDownloadsDirectory();
          if (dir == null) {
            throw "Sorry, we're unable to export your file at the moment";
          }
          directory = Directory(
              "${dir.path.replaceAll("/Android/data/", "/Android/media/")}/");
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.videos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        File saveFile = File("${directory.path}export_cards.json");
        return await copyContentToFile(context, content, saveFile);
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> copyContentToFile(
      BuildContext context, String content, File externalFile) async {
    // Open the external file for writing
    final IOSink externalSink = externalFile.openWrite();
    externalSink.write(content);

    // Close the file streams
    // await internalSink.drain();
    await externalSink.close();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('File contents copied successfully. ${externalFile.path}')));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              widget.onMenuPressed!();
            }),
        title: Text('CARDS REGISTRATION',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primaryColor, fontFamily: 'Iceberg')),
        actions: [
          // CustomIconButton(Icons.save, onPressed: () => exportToFile()),
          // CustomIconButton(Icons.delete,
          //     onPressed: () => CardsStorage().clearAllCards()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_card_outlined),
        onPressed: () {
          NavUtils.navTo(context, BulkCardsRegistration(), onReturn: (results) {
            if (results is List<CardModel>) {
              cubitContext?.read<CardsListCubit>().addCards(results);
            }
          });
        },
      ),
      body: BlocProvider<CardsListCubit>(
        create: (context) => CardsListCubit(CardsListState(),
            refreshController: refreshController),
        child: BlocBuilder<CardsListCubit, CardsListState>(
          builder: (context, state) {
            cubitContext = context;
            ScrollController controller = ScrollController();
            controller.addListener(() {
              if (controller.offset >= controller.position.maxScrollExtent) {
                debouncer(const Duration(milliseconds: 500),
                    () => BlocProvider.of<CardsListCubit>(context).nextPage());
              }

              if (controller.offset <= controller.position.minScrollExtent &&
                  !controller.position.outOfRange) {}
            });

            return SmartRefresher(
              enablePullDown: true,
              controller: refreshController,
              onRefresh: () {
                BlocProvider.of<CardsListCubit>(context).getData(refresh: true);
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Manage your cards"),
                        TextPopup(
                            list: const ["ALL", "VIP", "VVIP", "VVVIP"],
                            active: state.view ?? 0,
                            onSelected: (int i) {
                              BlocProvider.of<CardsListCubit>(context)
                                  .updateView(i);
                            })
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: state.results == null || state.results!.isEmpty
                          ? (state.error != null
                              ? ErrorPage(
                                  message: state.error!,
                                  onContinue: () {
                                    Navigator.pop(context);
                                  },
                                )
                              : EmptyResult(
                                  message: "No cards found",
                                  loading: state.loading ?? false,
                                ))
                          : AppTable(
                              columns: const ["S/N", "TYPE", "QR CODE", "RFID"],
                              data: state.results
                                      ?.map((e) =>
                                          [e.sno, e.type, e.qrCode, e.rfid])
                                      .toList() ??
                                  []),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Timer? canceller;
  void debouncer(Duration delay, Function fn) {
    if (canceller?.isActive ?? false) canceller?.cancel();
    canceller = Timer(delay, () {
      fn();
    });
  }
}
