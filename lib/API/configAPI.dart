// String baseUrl = 'http://localhost:5001';
String baseUrl = 'http://192.168.69.241:5001';
// String baseUrl = 'http://192.168.100.172:5001';

//users
String urlsignIn = "$baseUrl/user/login";
String urlupdatesaldo = "$baseUrl/user/update-balance";
String urltambahsaldo = "$baseUrl/user/add-balance";
String urlsignUp = "$baseUrl/user/register";
String urlchangepass = "$baseUrl/user/change-password";

// crud produk
String urlCreate = "$baseUrl/produk/create";
String urlEdit = "$baseUrl/produk/edit";
String urlgetAll = "$baseUrl/produk/getAll";
String urlHapus = "$baseUrl/produk/hapus";
String urlgetById = "$baseUrl/produk/getbyid";
String urlupdateProductQty = "$baseUrl/produk/updateqty";

// transaksi
String createTransaksi = "$baseUrl/transaksi/create";
String getTransaksi = "$baseUrl/transaksi/getbyiduser";
String urluploadbutki = "$baseUrl/transaksi/upload-bukti";
String getTransaksiById = "$baseUrl/transaksi/getbyiduserlimit";
