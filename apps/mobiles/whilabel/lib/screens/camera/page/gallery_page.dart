import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:whilabel/screens/camera/page/image_page.dart';
import 'package:whilabel/screens/camera/widget/gallery_album_picker.dart';
import 'package:whilabel/screens/constants/colors_manager.dart';
import 'package:whilabel/screens/constants/text_styles_manager.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<Album>? _albums;
  bool _loading = false;
  List<String> _albumNames = [];
  List<Medium> _media = [];

  @override
  void initState() {
    super.initState();
    _loading = true;
    initAsync();
  }

  Future<void> initAsync() async {
    if (await _promptPermissionSetting()) {
      List<Album> albums = await PhotoGallery.listAlbums();
      MediaPage mediaPage = await albums.first.listMedia();
      setState(() {
        _albums = albums;
        _media = mediaPage.items;
        // _loading = false;
      });
      Set<String?>? albumNames = _albums
          ?.map((album) => album.name)
          .where((name) => name != null && name.isNotEmpty)
          .toSet();
      setState(() {
        _albumNames = albumNames?.map((name) => name!).toList() ?? [];
      });
    }

    setState(() {
      _loading = false;
    });
  }

  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted ||
          await Permission.storage.request().isGranted) {
        return true;
      }
    }
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted ||
          await Permission.photos.request().isGranted &&
              await Permission.videos.request().isGranted) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // final viewModel =
    // final viewModel = context.read<CarmeraViewModel>();

    // 로딩 처리 코드
    if (_loading) {
      return SafeArea(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Timer(Duration(seconds: 5), () {
              Navigator.of(context).pop();
            });
          },
          // => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: ColorsManager.gray500,
          ),
        ),
        title: SizedBox(
          width: 200,
          child: GalleryAlbumPicker(
            albumNameList: _albumNames,
            onChangeAlbum: changeAlbum,
          ),
        ),
      ),
      body: SafeArea(
        child: _loading
            ? Stack(
                children: [
                  Positioned(
                    child: CircularProgressIndicator(),
                  ),
                ],
              )
            : GridView.builder(
                shrinkWrap: true,
                itemCount: _media.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
                  childAspectRatio: 1 / 1, //item 의 가로 1, 세로 1 의 비율
                  mainAxisSpacing: 4, //수평 Padding
                  crossAxisSpacing: 4, //수직 Padding
                ),
                itemBuilder: (BuildContext context, int index) {
                  Medium medium = _media[index];
                  if (medium.mediumType == MediumType.video) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: ColorsManager.gray500,
                        ),
                      ),
                      child: Center(
                        child: Text("Video",
                            style: TextStylesManager().createHadColorTextStyle(
                                "B16", ColorsManager.gray300)),
                      ),
                    );
                  }

                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ImagePage(
                          medium,
                          _media.indexOf(medium),
                        ),
                      ),
                    ),
                    child: SizedBox(
                      child: FadeInImage(
                        fit: BoxFit.cover,
                        placeholder: MemoryImage(kTransparentImage),
                        image: ThumbnailProvider(
                          mediumId: medium.id,
                          mediumType: medium.mediumType,
                          highQuality: true,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void changeAlbum(String albumTitle) async {
    List<Album> albums = await PhotoGallery.listAlbums();

    MediaPage mediaPage =
        await albums.firstWhere((item) => item.name == albumTitle).listMedia();
    setState(() {
      _albums = albums;
      _media = mediaPage.items;
      // _loading = false;
    });
    print("change tite====> $albumTitle");
  }
}
