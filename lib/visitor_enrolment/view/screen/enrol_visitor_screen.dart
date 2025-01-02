import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:shevarms_user/visitor_enrolment/visitor_enrolment.dart';

class EnrolVisitorScreen extends StatelessWidget {
  final VisitorModel? visitor;
  final bool allowMinimumData;
  const EnrolVisitorScreen(
      {this.visitor, Key? key, this.allowMinimumData = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();

    return BlocProvider(
      create: (_) => EnrolVisitorCubit(EnrolVisitorState(
          designation: visitor?.designation,
          phoneNumber: visitor?.phone,
          profilePicture: visitor?.picture,
          lastName: visitor?.lastName,
          firstName: visitor?.firstName,
          email: visitor?.email,
          address: visitor?.address,
          placeOfWork: visitor?.placeOfWork)),
      child: BlocBuilder<EnrolVisitorCubit, EnrolVisitorState>(
          builder: (context, state) {
        return BaseScaffold(
          appBarBackgroundColor: Colors.grey[100],
          textAndIconColors: Colors.black,
          title: RichText(
              text: TextSpan(children: [
            TextSpan(
              text: visitor == null ? "ENROL VISITOR" : "COMPLETE PROFILE",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: "Iceberg", color: Theme.of(context).primaryColor),
            ),
          ])),
          showBack: true,
          body: Container(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        ImagePickerUtil.pickImage().then((value) {
                          if (value != null) {
                            context
                                .read<EnrolVisitorCubit>()
                                .updateProfilePicture(value.path);
                          }
                        }).catchError((err) {
                          Alert.toast(context, message: err.toString());
                        });
                      },
                      child: Builder(
                        builder: (c) {
                          if (state.profilePicture == null) {
                            return DottedBorder(
                                borderType: BorderType.Circle,
                                color: Theme.of(context).primaryColor,
                                radius: const Radius.circular(150),
                                child: Image.asset(
                                  AssetConstants.imageNotFound,
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ));
                          } else if (state.profilePicture!.startsWith("http")) {
                            return CardImage(
                              imageString: state.profilePicture!,
                              size: const Size(150, 150),
                              radius: 150,
                            );
                          } else {
                            return CardFileImage(
                              imageString: state.profilePicture!,
                              size: const Size(150, 150),
                              radius: 150,
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        "Select profile picture${allowMinimumData ? " (Optional)" : ""}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 20),
                    AppTextField(
                      validator: (text) => text == null || text.isEmpty
                          ? "Field is required"
                          : null,
                      labelText: "First name",
                      keyboardType: TextInputType.name,
                      hintText: "Enter first name",
                      onChange: (s) =>
                          context.read<EnrolVisitorCubit>().updateFirstName(s),
                      initialValue: state.firstName,
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      validator: (text) => text == null || text.isEmpty
                          ? "Field is required"
                          : null,
                      labelText: "Last name",
                      keyboardType: TextInputType.name,
                      hintText: "Enter last name",
                      initialValue: state.lastName,
                      onChange: (s) =>
                          context.read<EnrolVisitorCubit>().updateLastName(s),
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      validator: (text) => text == null || text.isEmpty
                          ? "Field is required"
                          : null,
                      labelText: "Phone number",
                      keyboardType: TextInputType.number,
                      hintText: "Enter phone number",
                      initialValue: state.phoneNumber,
                      onChange: (s) => context
                          .read<EnrolVisitorCubit>()
                          .updatePhoneNumber(s),
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      labelText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      hintText: "Enter email address",
                      initialValue: state.email,
                      onChange: (s) =>
                          context.read<EnrolVisitorCubit>().updateEmail(s),
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      labelText: "Address",
                      validator: (text) =>
                          !allowMinimumData && (text == null || text.isEmpty)
                              ? "Field is required"
                              : null,
                      keyboardType: TextInputType.streetAddress,
                      hintText: "Street address",
                      maxLines: 3,
                      initialValue: state.address,
                      onChange: (s) =>
                          context.read<EnrolVisitorCubit>().updateAddress(s),
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      labelText: "Place of Work",
                      validator: (text) =>
                          !allowMinimumData && (text == null || text.isEmpty)
                              ? "Field is required"
                              : null,
                      keyboardType: TextInputType.name,
                      hintText: "Place of Work",
                      initialValue: state.placeOfWork,
                      onChange: (s) => context
                          .read<EnrolVisitorCubit>()
                          .updatePlaceOfWork(s),
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      labelText: "Designation",
                      validator: (text) =>
                          !allowMinimumData && (text == null || text.isEmpty)
                              ? "Field is required"
                              : null,
                      keyboardType: TextInputType.name,
                      hintText: "Designation",
                      initialValue: state.designation,
                      onChange: (s) => context
                          .read<EnrolVisitorCubit>()
                          .updateDesignation(s),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 30,
                      child: Center(
                          child: Text(state.error ?? "",
                              maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ),
                    Center(
                      child: AppTextButton(
                        buttonColor: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        loading: state.loading ?? false,
                        width: MediaQuery.of(context).size.width - 100,
                        label: "CONTINUE",
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          if (state.profilePicture == null &&
                              !allowMinimumData) {
                            Alert.toast(context,
                                message: "Please capture profile picture");
                            return;
                          }
                          // try{
                          await context
                              .read<EnrolVisitorCubit>()
                              .enrol((newUser) {
                            NavUtils.navTo(
                                context,
                                SuccessPage(
                                    message:
                                        "You have successfully enrolled a new visitor",
                                    onContinue: (c) {
                                      Navigator.pop(c, newUser);
                                      Navigator.pop(c, newUser);
                                    }));
                          });
                          // }catch(e){
                          //   print(e);
                          // }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                        "By proceeding you agree to the terms and conditions of this platform",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
