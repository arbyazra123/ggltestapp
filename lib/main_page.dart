import 'package:flutter/material.dart';
import 'package:ggltestapp/database.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Map<String, dynamic>>? res = [];
  var loading = true;
  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() async {
    res = await ProductDB.getAllProduct();
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemCount: res?.length ?? 0,
                itemBuilder: (context, index) => ListTile(
                  title: Text("kd:${res![index]['kode_barang']}, nm:${res![index]['nama_barang']}, in/out:${res![index]['jenis_stok']}, totalbrg:${res![index]['total_barang']}"),

                ),
              ));
  }
}
