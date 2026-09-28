import 'dart:io';
import 'dart:collection';

void main() {
  // Pos cuci mobil (Key: Nama Pos, Value: Plat Mobil / null jika kosong)
  Map<String, String?> posList = {
    'Pos A': null,
    'Pos B': null,
    'Pos C': null,
  };

  // Antrian untuk waiting list
  Queue<String> waitingList = Queue<String>();

  while (true) {
    print('\n====================================');
    print('   SISTEM ANTRIAN CUCI MOBIL');
    print('====================================');
    print('1. Tambah Antrian');
    print('2. Lihat Waiting List');
    print('3. Lihat Pos');
    print('4. Selesaikan Pos');
    print('5. Keluar dari Aplikasi');
    stdout.write('Pilih menu (1-5): ');

    String? input = stdin.readLineSync();

    switch (input) {
      case '1':
        tambahAntrian(posList, waitingList);
        break;
      case '2':
        lihatWaitingList(waitingList);
        break;
      case '3':
        lihatPos(posList);
        break;
      case '4':
        selesaikanPos(posList, waitingList);
        break;
      case '5':
        exit(0);
      default:
        print('\nPilihan tidak valid. Silakan coba lagi (1-5).');
    }
  }
}

// 1. Tambah Antrian
void tambahAntrian(Map<String, String?> posList, Queue<String> waitingList) {
  stdout.write('\nMasukkan Plat Nomor Mobil: ');
  String? plat = stdin.readLineSync();

  if (plat == null || plat.trim().isEmpty) {
    print('Plat nomor tidak boleh kosong!');
    return;
  }

  plat = plat.trim().toUpperCase();

  // Cari pos yang masih kosong
  String? posKosong;
  for (var entry in posList.entries) {
    if (entry.value == null) {
      posKosong = entry.key;
      break;
    }
  }

  // Jika ada pos kosong, langsung masukkan
  if (posKosong != null) {
    posList[posKosong] = plat;
    print('--> Mobil $plat berhasil masuk ke [$posKosong].');
  } else {
    // Jika semua pos penuh, masukkan ke waiting list
    waitingList.add(plat);
    print('--> Semua pos penuh! Mobil $plat masuk ke [Waiting List] (Urutan ke-${waitingList.length}).');
  }
}

// 2. Lihat Waiting List
void lihatWaitingList(Queue<String> waitingList) {
  print('\n------------------------------------');
  print('          WAITING LIST');
  print('------------------------------------');
  if (waitingList.isEmpty) {
    print('Tidak ada mobil di waiting list.');
  } else {
    int i = 1;
    for (var plat in waitingList) {
      print('$i. Mobil Plat: $plat');
      i++;
    }
  }
}

// 3. Lihat Pos
void lihatPos(Map<String, String?> posList) {
  print('\n------------------------------------');
  print('            STATUS POS');
  print('------------------------------------');
  posList.forEach((pos, plat) {
    String status = plat == null ? 'KOSONG' : '$plat';
    print('$pos : $status');
  });
}

// 4. Selesaikan Pos
void selesaikanPos(Map<String, String?> posList, Queue<String> waitingList) {
  print('\n------------------------------------');
  print('          SELESAIKAN POS');
  print('------------------------------------');
  print('1. Selesaikan Pos A');
  print('2. Selesaikan Pos B');
  print('3. Selesaikan Pos C');
  stdout.write('Pilih pos yang selesai :');

  String? pilihan = stdin.readLineSync();
  String? targetPos;

  if (pilihan == 'A') targetPos = 'Pos A';
  if (pilihan == 'B') targetPos = 'Pos B';
  if (pilihan == 'C') targetPos = 'Pos C';

  if (targetPos == null) {
    print('Pilihan pos tidak valid!');
    return;
  }

  if (posList[targetPos] == null) {
    print('$targetPos sedang kosong, tidak ada mobil yang dicuci.');
    return;
  }

  print('\n--> Pencucian mobil [${posList[targetPos]}] di $targetPos SELESAI!');
  posList[targetPos] = null;

  // Jika ada antrian di waiting list, masukkan mobil terdepan ke pos yang baru kosong
  if (waitingList.isNotEmpty) {
    String mobilBerikutnya = waitingList.removeFirst();
    posList[targetPos] = mobilBerikutnya;
    print('--> Mobil [$mobilBerikutnya] dari Waiting List otomatis masuk ke [$targetPos].');
  }
}