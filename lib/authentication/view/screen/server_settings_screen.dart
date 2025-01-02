import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/shared/shared.dart';

class ServerSettingsPage extends StatefulWidget {
  static const String routeKey = "serverSettings";
  final bool showBack;
  const ServerSettingsPage({this.showBack = true, Key? key}) : super(key: key);

  @override
  State<ServerSettingsPage> createState() => _ServerSettingsPageState();
}

class _ServerSettingsPageState extends State<ServerSettingsPage> {
  late TextEditingController url;

  bool loading = false;
  String stat = "";
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    url = TextEditingController.fromValue(TextEditingValue(
        text: context.read<SettingsCubit>().settings.baseUrl ??
            DioClient().baseUrl));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(builder: (context, state) {
      return BaseScaffold(
        appBarBackgroundColor: Colors.white,
        textAndIconColors: Colors.black,
        showBack: widget.showBack,
        noGradient: true,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: MediaQuery.of(context).size.height - 50,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CardAssetImage(
                    imageString: AssetConstants.logoBig,
                    size: const Size(120, 120),
                    borderColor: Colors.grey.shade200,
                    radius: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: "Server ",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGrey),
                    ),
                    TextSpan(
                      text: "Settings",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor),
                    ),
                  ])),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Modify location of the server",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 20),
                  AppTextField(
                    validator: (text) => text == null || text.isEmpty
                        ? "Field is required"
                        : null,
                    labelText: "Base Url",
                    controller: url,
                    hintText: "https://vms.zsgov.ng",
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: AppTextButton(
                      buttonColor: AppColors.primaryColor,
                      textColor: Colors.white,
                      width: MediaQuery.of(context).size.width - 100,
                      label: "SAVE",
                      onPressed: () {
                        if (!formKey.currentState!.validate()) return;
                        context.read<SettingsCubit>().updateServerUrl(url.text);
                        Alert.toast(context, message: "Settings saved!");
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Login?",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold)))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
