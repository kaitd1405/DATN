import 'package:card_swiper/card_swiper.dart';
import 'package:dio/dio.dart';
import 'package:ebookapp/controller/api.dart';
import 'package:ebookapp/controller/con_category.dart';
import 'package:ebookapp/controller/con_coming.dart';
import 'package:ebookapp/controller/con_latest.dart';
import 'package:ebookapp/controller/con_slider.dart';
import 'package:ebookapp/model/category/model_category.dart';
import 'package:ebookapp/model/ebook/model_ebook.dart';
import 'package:ebookapp/model/function/functions.dart';
import 'package:ebookapp/view/category/ebook_category.dart';
import 'package:ebookapp/view/detail/ebook_detail.dart';
import 'package:ebookapp/view/list_books_screen.dart';
import 'package:ebookapp/view/search/search_screen.dart';
import 'package:ebookapp/widget/common_pref.dart';
import 'package:ebookapp/widget/ebook_routes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<ModelEbook>> getSlider;
  List<ModelEbook> listSlider = [];

  late Future<List<ModelEbook>> getLatest;
  List<ModelEbook> listLatest = [];

  late Future<List<ModelEbook>> getComing;
  List<ModelEbook> listComing = [];

  late Future<List<ModelCategory>> getCategory;
  List<ModelCategory> listCategory = [];
  List<ModelEbook> fakeEbookList = [
    ModelEbook(
      id: 1,
      title: 'Flutter for Beginners',
      photo: 'https://example.com/photos/flutter_beginners.jpg',
      description: 'A comprehensive guide to learning Flutter.',
      catId: 101,
      statusNews: 1,
      pdf: 'https://example.com/ebooks/flutter_beginners.pdf',
      date: '2024-08-10',
      authorName: 'John Doe',
      publisherName: 'Tech Books Publishing',
      pages: 350,
      language: 'English',
      rating: 4,
      free: 1,
    ),
    ModelEbook(
      id: 2,
      title: 'Advanced Flutter Techniques',
      photo: 'https://example.com/photos/flutter_advanced.jpg',
      description: 'Take your Flutter skills to the next level.',
      catId: 102,
      statusNews: 1,
      pdf: 'https://example.com/ebooks/flutter_advanced.pdf',
      date: '2024-08-09',
      authorName: 'Jane Smith',
      publisherName: 'Innovative Publishing',
      pages: 500,
      language: 'English',
      rating: 5,
      free: 0,
    ),
    ModelEbook(
      id: 3,
      title: 'Dart Programming Language',
      photo: 'https://example.com/photos/dart_programming.jpg',
      description: 'Master the Dart programming language.',
      catId: 103,
      statusNews: 1,
      pdf: 'https://example.com/ebooks/dart_programming.pdf',
      date: '2024-08-08',
      authorName: 'Emily Johnson',
      publisherName: 'Code Masters Publishing',
      pages: 400,
      language: 'English',
      rating: 4,
      free: 1,
    ),
    ModelEbook(
      id: 4,
      title: 'Flutter UI Design Patterns',
      photo: 'https://example.com/photos/flutter_ui_design.jpg',
      description: 'Explore best practices for Flutter UI design.',
      catId: 104,
      statusNews: 1,
      pdf: 'https://example.com/ebooks/flutter_ui_design.pdf',
      date: '2024-08-07',
      authorName: 'David Lee',
      publisherName: 'Creative Coding Press',
      pages: 300,
      language: 'English',
      rating: 3,
      free: 0,
    ),
    ModelEbook(
      id: 5,
      title: 'Building Real-Time Apps with Flutter',
      photo: 'https://example.com/photos/flutter_realtime_apps.jpg',
      description: 'Learn to build real-time applications using Flutter.',
      catId: 105,
      statusNews: 1,
      pdf: 'https://example.com/ebooks/flutter_realtime_apps.pdf',
      date: '2024-08-06',
      authorName: 'Sophia Williams',
      publisherName: 'App Dev Publishing',
      pages: 450,
      language: 'English',
      rating: 5,
      free: 1,
    ),
  ];

  String id = '', name = '', email = '', photo = '';

  @override
  void initState() {
    super.initState();
    getSlider = fetchSlider(listSlider);
    getLatest = fetchLatest(listLatest);
    getComing = fetchComing(listComing);
    getCategory = fetchCategory(listCategory);

    loadLogin().then((value) {
      setState(() {
        id = value[0];
        name = value[1];
        email = value[2];
        // photo = value[3];
        getPhoto(id);
      });
    });
  }

  Future getPhoto(String idOfUser) async {
    var req = await Dio().post(
        ApiConstant().baseUrl() + ApiConstant().viewPhoto,
        data: {'id': idOfUser});
    var decode = req.data;
    if (decode != 'no_img') {
      setState(() {
        photo = decode;
      });
    } else {
      setState(() {
        photo = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                pushPage(context, const SearchScreen());
              },
              child: const Icon(Icons.search))
        ],
        backgroundColor: Colors.white70,
        elevation: 0,
        title: Row(
          children: [
            Container(
              child: photo == ''
                  ? ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
                      child: Image.asset('asset/images/register.png',
                          fit: BoxFit.cover, width: 14.w, height: 7.h))
                  : ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      child: Image.network(Functions.fixImage(photo),
                          fit: BoxFit.cover, width: 14.w, height: 7.h)),
            ),
            SizedBox(
              width: 2.w,
            ),
            Text(
              name,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: getSlider,
              builder: (BuildContext context,
                  AsyncSnapshot<List<ModelEbook>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      //*Slider
                      FutureBuilder<List<ModelEbook>>(
                          future: getSlider,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              //Create design in here
                              return SizedBox(
                                height: 27.0.h,
                                child: Swiper(
                                    itemCount: snapshot.data!.length,
                                    autoplay: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () => pushPage(
                                            context,
                                            EbookDetail(
                                              ebookId: snapshot.data![index].id,
                                              status: snapshot
                                                  .data![index].statusNews,
                                            )),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Container(
                                            child: Stack(children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Image.network(
                                                    Functions.fixImage(snapshot
                                                        .data![index].photo),
                                                    fit: BoxFit.fill,
                                                    width: 100.0.w),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        bottomLeft:
                                                            Radius.circular(15),
                                                        bottomRight:
                                                            Radius.circular(15),
                                                      ),
                                                      gradient: LinearGradient(
                                                          end: const Alignment(
                                                              0.0, -1),
                                                          begin:
                                                              const Alignment(
                                                                  0, 0.2),
                                                          colors: [
                                                            Colors.black54,
                                                            Colors.black
                                                                .withOpacity(
                                                                    0.1),
                                                          ])),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Text(
                                                      snapshot
                                                          .data![index].title,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 17,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]),
                                          ),
                                        ),
                                      );
                                    }),
                              );
                            }
                            return Container();
                          }),
                      //* Latest book
                      FutureBuilder<List<ModelEbook>>(
                        future: getLatest,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Latest book',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 17),
                                  ),
                                ),
                                SizedBox(
                                  height: 27.h,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data!.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == snapshot.data!.length) {
                                        return GestureDetector(
                                          onTap: () {
                                            pushPage(context,
                                                const ListBooksScreen());
                                          },
                                          child: Container(
                                              width: 24.w,
                                              padding:
                                                  EdgeInsets.only(top: 15.w),
                                              child: const Text(
                                                'See All',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 16),
                                                textAlign: TextAlign.center,
                                              )),
                                        );
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          pushPage(
                                              context,
                                              EbookDetail(
                                                  ebookId:
                                                      snapshot.data![index].id,
                                                  status: snapshot.data![index]
                                                      .statusNews));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          child: Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  Functions.fixImage(snapshot
                                                      .data![index].photo),
                                                  fit: BoxFit.cover,
                                                  height: 15.h,
                                                  width: 24.w,
                                                ),
                                              ),
                                              SizedBox(height: 0.5.h),
                                              SizedBox(
                                                width: 24.w,
                                                child: Text(
                                                  snapshot.data![index].title,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                      //* Cooming soon
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: FutureBuilder<List<ModelEbook>>(
                            future: getComing,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return snapshot.data!.isEmpty
                                    ? Container()
                                    : Container(
                                        color: Colors.blueGrey.withOpacity(0.5),
                                        padding: EdgeInsets.only(top: 2.0.h),
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(top: 5.h),
                                                  child: const Text(
                                                    'Coming soon',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 35,
                                                        letterSpacing: 10),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: 24.h,
                                                child: ListView.builder(
                                                    itemCount:
                                                        snapshot.data!.length,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          pushPage(
                                                              context,
                                                              EbookDetail(
                                                                  ebookId: snapshot
                                                                      .data![
                                                                          index]
                                                                      .id,
                                                                  status: snapshot
                                                                      .data![
                                                                          index]
                                                                      .statusNews));
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                child: Image
                                                                    .network(
                                                                  Functions.fixImage(
                                                                      snapshot
                                                                          .data![
                                                                              index]
                                                                          .photo),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 15.h,
                                                                  width: 24.w,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height:
                                                                      0.5.h),
                                                              SizedBox(
                                                                width: 24.w,
                                                                child: Text(
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .title,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }))
                                          ],
                                        ),
                                      );
                              }
                              return Container();
                            }),
                      ),
                      //*Category
                      Container(
                        child: FutureBuilder<List<ModelCategory>>(
                          future: getCategory,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      'Category',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14.h,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              pushPage(
                                                  context,
                                                  EbookCategory(
                                                      catId: snapshot
                                                          .data![index].catId));
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      Functions.fixImage(
                                                          snapshot.data![index]
                                                              .photoCat),
                                                      fit: BoxFit.cover,
                                                      height: 15.h,
                                                      width: 24.w,
                                                    ),
                                                  ),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Container(
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                      height: 15.h,
                                                      width: 24.w,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    left: 0,
                                                    right: 0,
                                                    top: 0,
                                                    child: Center(
                                                      child: Text(
                                                        snapshot
                                                            .data![index].name,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        maxLines: 1,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                ],
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                    ],
                  );
                }
                return const Center(
                  child: Text('Loading'),
                );
              }),
        ),
      ),
    );
  }
}
