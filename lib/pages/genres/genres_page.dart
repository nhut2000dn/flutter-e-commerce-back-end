import 'package:admin_dashboard/helpers/enumerators.dart';
import 'package:admin_dashboard/provider/tables.dart';
import 'package:admin_dashboard/rounting/route_names.dart';
import 'package:admin_dashboard/services/genre.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/ResponsiveDatatable.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/responsive_table.dart';

import '../../locator.dart';

class GenresPage extends StatefulWidget {
  @override
  _GenresPageState createState() => _GenresPageState();
}

class _GenresPageState extends State<GenresPage> {
  late TextEditingController inputSearchController;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    inputSearchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final GenreService _genreService = GenreService();
    final TablesProvider tablesProvider = Provider.of<TablesProvider>(context);
    List<DatatableHeader> genresTableHeader = [
      DatatableHeader(
          text: "ID",
          value: "id",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Name",
          value: "name",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Description",
          value: "description",
          show: true,
          sortable: true,
          sourceBuilder: (value, row) {
            return Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            );
          },
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Image",
          value: "image",
          show: true,
          flex: 2,
          sortable: true,
          sourceBuilder: (value, row) {
            return SizedBox(
              width: 50.0,
              height: 50.0,
              child: CircleAvatar(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: (value != '')
                        ? FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            placeholder: 'images/loading.gif',
                            image: value)
                        : const Image(image: AssetImage('images/no_image.jpg')),
                  ),
                ),
                foregroundColor: Colors.black,
              ),
            );
          },
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Action",
          value: "id",
          show: true,
          sortable: true,
          sourceBuilder: (value, row) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: Icon(
                    Icons.delete,
                    color: Colors.red[700],
                  ),
                  onTap: () async {
                    Widget cancelButton = TextButton(
                      child: Text("Cancel"),
                      onPressed: () {},
                    );
                    Widget continueButton = TextButton(
                      child: Text("Continue"),
                      onPressed: () async {
                        bool check = await _genreService.deleteGenre(row['id']);
                        if (check) {
                          tablesProvider.removeFromTable(Tables.genres, value);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Delete Genre Succesful!"),
                            ),
                          );
                        }
                      },
                    );

                    // set up the AlertDialog
                    AlertDialog alert = AlertDialog(
                      title: Text("Comfirm"),
                      content: Text("Are you sure delete"),
                      actions: [
                        cancelButton,
                        continueButton,
                      ],
                    );

                    // show the dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  },
                ),
                InkWell(
                  child: Icon(
                    Icons.edit,
                    color: Colors.green[700],
                  ),
                  onTap: () {
                    locator<NavigationService>()
                        .navigateToWithArgument(EditGenreRoute, row);
                  },
                ),
              ],
            );
          },
          textAlign: TextAlign.center),
    ];
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const PageHeader(
            text: 'GENRES',
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(0),
            constraints: const BoxConstraints(
              maxHeight: 700,
            ),
            child: Card(
              elevation: 1,
              shadowColor: Colors.black,
              clipBehavior: Clip.none,
              child: ResponsiveDatatable(
                title: !tablesProvider.isSearch
                    ? RaisedButton.icon(
                        onPressed: () {
                          locator<NavigationService>()
                              .navigateTo(AddGenreRoute);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("ADD GENRE"))
                    : null,
                actions: [
                  if (tablesProvider.isSearch)
                    DropdownButton(
                      itemHeight: 64,
                      value: tablesProvider.fieldGenreCurrent,
                      items: tablesProvider.fieldsGenre
                          .map(
                            (value) => DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        debugPrint(value.toString());
                        tablesProvider.onChangeFieldCurrent(
                          Tables.genres,
                          value.toString(),
                        );
                      },
                    ),
                  if (tablesProvider.isSearch)
                    Expanded(
                      child: TextField(
                        controller: inputSearchController,
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () {
                              setState(
                                () {
                                  tablesProvider.isSearch = false;
                                  tablesProvider.resestData(Tables.genres);
                                },
                              );
                            },
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              tablesProvider.onSearch(
                                  Tables.genres, inputSearchController.text);
                            },
                          ),
                        ),
                      ),
                    ),
                  if (!tablesProvider.isSearch)
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(
                          () {
                            tablesProvider.isSearch = true;
                          },
                        );
                      },
                    )
                ],
                headers: genresTableHeader,
                source: tablesProvider.genresTableSource,
                selecteds: tablesProvider.selecteds,
                showSelect: tablesProvider.showSelect,
                autoHeight: false,
                onSort: (value) => tablesProvider.onSort(value, Tables.genres),
                sortAscending: tablesProvider.sortAscending,
                sortColumn: tablesProvider.sortColumn,
                isLoading: tablesProvider.isLoading,
                onSelect: tablesProvider.onSelected,
                onSelectAll: tablesProvider.onSelectAll,
                footers: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                        "Number of Genres: ${tablesProvider.genresTableSource.length}"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
