
class Barang{
  String? id;
  final String kode;
  final String nama;
  final String gambar;

  Barang(this.kode, this.nama, this.gambar);
}

class Stok{
  String? id;
  final String id_barang;
  final int total_barang;
  final int jenis_stok;

  Stok(this.id_barang, this.total_barang, this.jenis_stok);
}