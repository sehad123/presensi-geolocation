import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';
import '../controllers/list_ruangan_controller.dart';

// ... (import statement tetap sama)

class ListRuanganView extends GetView<ListRuanganController> {
  const ListRuanganView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List RuanganView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('Filter by Status:'),
                const SizedBox(width: 10),
                Obx(() {
                  return DropdownButton<String>(
                    value: controller.selectedStatus.value,
                    onChanged: (value) {
                      controller.filterByStatus(value!);
                    },
                    items: <String>['Semua', 'ada', 'Booking', 'Terpakai']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => controller.ruanganList.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada ruangan.',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : ListView.builder(
                      itemCount: controller.ruanganList.length,
                      itemBuilder: (context, index) {
                        var ruangan = controller.ruanganList[index];
                        return ListTile(
                          title: Text('Nomor Ruangan: ${ruangan["nomor"]}'),
                          subtitle: Text('Status: ${ruangan["status"]}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Get.toNamed(Routes.EDIT_RUANGAN,
                                      arguments: ruangan);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Panggil fungsi untuk menghapus ruangan
                                  controller.deleteRuangan(ruangan["uid"]);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman penambahan ruangan
          Get.toNamed(Routes.ADD_RUANGAN);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
