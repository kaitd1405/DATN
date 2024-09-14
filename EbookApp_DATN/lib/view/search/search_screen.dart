import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../controller/con_search.dart';
import '../../model/ebook/model_ebook.dart';
import '../../model/function/functions.dart';
import '../../widget/ebook_routes.dart';
import '../detail/ebook_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<List<ModelEbook>>? getSearch;
  List<ModelEbook> listEbookSearch = [];

  // Assuming fetchSearch is a function to fetch search results
  Future<void> actionSearch(String query) async {
    // Replace the below logic with your actual network request
    // This is just a placeholder for demonstration
    setState(() {
      getSearch =
          fetchSearch(listEbookSearch, query); // Assuming this function exists
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Books'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final String? selected = await showSearch<String>(
                context: context,
                delegate: BookSearchDelegate(actionSearch),
              );
              if (selected != null && selected.isNotEmpty) {
                actionSearch(selected);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<ModelEbook>>(
          future: getSearch,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 5.5 / 9.0,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      pushPage(
                        context,
                        EbookDetail(
                          ebookId: snapshot.data![index].id,
                          status: snapshot.data![index].statusNews,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              Functions.fixImage(snapshot.data![index].photo),
                              fit: BoxFit.cover,
                              height: 15.h,
                              width: 24.w,
                            ),
                          ),
                          const SizedBox(height: 0.7),
                          SizedBox(
                            width: 24.w,
                            child: Text(
                              snapshot.data![index].title,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return const Center(
              child: Text(
                "Search books with your key word",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BookSearchDelegate extends SearchDelegate<String> {
  final Function(String) onSearch;

  BookSearchDelegate(this.onSearch);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    close(context, query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
