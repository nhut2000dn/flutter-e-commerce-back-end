// ignore_for_file: deprecated_member_use
import 'package:admin_dashboard/models/users.dart';
import 'package:admin_dashboard/services/users_novels.dart';
import 'package:admin_dashboard/services/users_products.dart';
import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
// ignore: import_of_legacy_library_into_null_safe

import '../custom_text.dart';
import '../loading_opacity.dart';
import '../page_header.dart';

// ignore: must_be_immutable
class AddUserNovels extends StatefulWidget {
  final String id;
  final List<UserModel> users;
  final Function notifyAndRefresh;

  const AddUserNovels({
    Key? key,
    required this.id,
    required this.users,
    required this.notifyAndRefresh,
  }) : super(key: key);

  @override
  _AddUserNovelsState createState() => _AddUserNovelsState();
}

class _AddUserNovelsState extends State<AddUserNovels> {
  late UserModel userCurrent;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  initData() async {
    setState(() {
      userCurrent = widget.users[0];
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 400,
      child: Stack(
        children: [
          Opacity(
            opacity: isLoading
                ? 0.5
                : 1, // You can reduce this when loading to give different effect
            child: AbsorbPointer(
              absorbing: isLoading,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      text: 'ADD FAVOURITER',
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(0),
                      constraints: const BoxConstraints(
                        maxHeight: 190,
                        maxWidth: 400,
                      ),
                      child: Card(
                        elevation: 1,
                        shadowColor: Colors.black,
                        clipBehavior: Clip.none,
                        child: Container(
                          color: Colors.white,
                          child: ListView(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    color: const Color(0xffFFFFFF),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 25.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: SizedBox(
                                              child: Text(
                                                'users: ',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.grey[200]),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: DropdownButton(
                                                        isExpanded: true,
                                                        value: userCurrent,
                                                        items: widget.users
                                                            .map(
                                                              (value) =>
                                                                  DropdownMenuItem(
                                                                child: Text(
                                                                    value
                                                                        .email),
                                                                value: value,
                                                              ),
                                                            )
                                                            .toList(),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            userCurrent = value
                                                                as UserModel;
                                                          });
                                                          debugPrint(
                                                              value.toString());
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.indigo),
                                              child: FlatButton(
                                                onPressed: () async {
                                                  bool check =
                                                      await UsersProductsService()
                                                          .addUserNovel({
                                                    'product_id': widget.id,
                                                    'user_id':
                                                        userCurrent.userId,
                                                  });
                                                  if (check) {
                                                    Navigator.of(context).pop();
                                                  }
                                                  widget.notifyAndRefresh(
                                                      check, userCurrent);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 4),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      CustomText(
                                                        text: "ADD",
                                                        size: 22,
                                                        color: Colors.white,
                                                        weight: FontWeight.bold,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Opacity(
              opacity: isLoading ? 1.0 : 0,
              child: isLoading ? const LoadingOpacity() : Container()),
        ],
      ),
    );
  }
}
