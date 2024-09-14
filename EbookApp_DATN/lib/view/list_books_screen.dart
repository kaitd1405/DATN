import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../controller/con_latest.dart';
import '../model/ebook/model_ebook.dart';
import '../model/function/functions.dart';
import '../widget/ebook_routes.dart';
import 'detail/ebook_detail.dart';

class ListBooksScreen extends StatefulWidget {
  const ListBooksScreen({super.key});

  @override
  State<ListBooksScreen> createState() => _ListBooksScreenState();
}

class _ListBooksScreenState extends State<ListBooksScreen> {
  late Future<List<ModelEbook>> getLatest;
  List<ModelEbook> listLatest = [];

  @override
  void initState() {
    getLatest = fetchLatest(listLatest);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Lastest Book")),
        actions: const [
          SizedBox(
            width: 40,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<ModelEbook>>(
              future: getLatest,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio:
                            0.75,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            pushPage(
                                context,
                                EbookDetail(
                                    ebookId: snapshot.data![index].id,
                                    status: snapshot.data![index].statusNews));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    Functions.fixImage(
                                        snapshot.data![index].photo),
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                    height:
                                        150.0, // Chiều cao cố định của hình ảnh
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                SizedBox(
                                  width: double.infinity,
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
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
