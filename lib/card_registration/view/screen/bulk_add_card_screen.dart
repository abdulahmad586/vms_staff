import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/card_registration/card_registration.dart';
import 'package:shevarms_user/shared/shared.dart';

class BulkCardsRegistration extends KFDrawerContent {
  @override
  State<BulkCardsRegistration> createState() => _BulkCardsRegistrationState();
}

class _BulkCardsRegistrationState extends State<BulkCardsRegistration> {
  RefreshController refreshController = RefreshController();

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BulkCardAddCubit>(
      create: (context) => BulkCardAddCubit(BulkCardAddState(),
          refreshController: refreshController),
      child: BlocBuilder<BulkCardAddCubit, BulkCardAddState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('BULK REGISTRATION',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primaryColor,
                        fontFamily: 'Iceberg',
                      )),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add_card_outlined),
              onPressed: () {
                Alert.showAppDialog(
                    context,
                    "Select Card Type",
                    SizedBox(
                      height: 200,
                      width: 400,
                      child: ListView(
                        children: [
                          "HE's Office",
                          "Chief of Staff",
                          "Deputy Chief of Staff",
                          "Admin Block",
                          "ZITDA",
                          "Protocol",
                          "Governor's Block",
                          "S.A Block",
                          "First Lady",
                          "SSG",
                          "VIP 1",
                          "VIP 2",
                          "VIP 3"
                        ]
                            .map((e) => ListTile(
                                  title: Text(e),
                                  onTap: () {
                                    String cardType = e;
                                    NavUtils.navTo(
                                        context,
                                        AddCardScreen(
                                          cardType,
                                          onCardAdded: (card) {
                                            //async card
                                            context
                                                .read<BulkCardAddCubit>()
                                                .addCards([card]);
                                          },
                                        ), onReturn: (card) {
                                      if (card != null) {
                                        context
                                            .read<BulkCardAddCubit>()
                                            .addCards([card as CardModel]);
                                      }
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                    ));
              },
            ),
            body: SmartRefresher(
              enablePullDown: true,
              controller: refreshController,
              onRefresh: () {
                BlocProvider.of<BulkCardAddCubit>(context)
                    .getData(refresh: true);
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
                        const Text("Add cards and upload"),
                        AppTextButton(
                          loading: state.syncing ?? false,
                          onPressed: () async {
                            try {
                              final cards = await context
                                  .read<BulkCardAddCubit>()
                                  .uploadCards();
                              Navigator.pop(context, cards);
                            } catch (e) {
                              if (context.mounted) {
                                Alert.toast(context, message: e.toString());
                              }
                            }
                          },
                          textColor: (state.cards?.isEmpty ?? true)
                              ? Colors.grey
                              : AppColors.primaryColor,
                          label: 'Upload',
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: state.cards == null || state.cards!.isEmpty
                          ? (state.error != null
                              ? ErrorPage(
                                  message: state.error!,
                                  onContinue: () {
                                    Navigator.pop(context);
                                  },
                                )
                              : EmptyResult(
                                  message: "No cards found",
                                  loading: state.syncing ?? false,
                                ))
                          : AppTable(
                              columns: const ["S/N", "TYPE", "QR CODE", "RFID"],
                              data: state.cards
                                      ?.map((e) =>
                                          [e.sno, e.type, e.qrCode, e.rfid])
                                      .toList() ??
                                  [],
                              actionsBuilder: (index) {
                                return Row(
                                  children: [
                                    CustomIconButton(Icons.edit, onPressed: () {
                                      NavUtils.navTo(
                                          context,
                                          AddCardScreen(
                                              state.cards![index].type,
                                              card: state.cards?[index]),
                                          onReturn: (editedCard) {
                                        if (editedCard != null) {
                                          context
                                              .read<BulkCardAddCubit>()
                                              .updateItem(index,
                                                  editedCard as CardModel);
                                        }
                                      });
                                    }),
                                    CustomIconButton(Icons.delete,
                                        onPressed: () {
                                      Alert.caution(context,
                                          title: "Delete Record?",
                                          message:
                                              "Are you sure you want to delete this record?",
                                          onProceed: () => context
                                              .read<BulkCardAddCubit>()
                                              .removeItem(
                                                  index, state.cards![index]));
                                    }),
                                  ],
                                );
                              }),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
