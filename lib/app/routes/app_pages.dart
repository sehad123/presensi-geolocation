import 'package:get/get.dart';

import '../modules/add_dosen/bindings/add_dosen_binding.dart';
import '../modules/add_dosen/views/add_dosen_view.dart';
import '../modules/add_jadwal/bindings/add_jadwal_binding.dart';
import '../modules/add_jadwal/views/add_jadwal_view.dart';
import '../modules/add_jadwal_dosen/bindings/add_jadwal_dosen_binding.dart';
import '../modules/add_jadwal_dosen/views/add_jadwal_dosen_view.dart';
import '../modules/add_pegawai/bindings/add_pegawai_binding.dart';
import '../modules/add_pegawai/views/add_pegawai_view.dart';
import '../modules/add_ruangan/bindings/add_ruangan_binding.dart';
import '../modules/add_ruangan/views/add_ruangan_view.dart';
import '../modules/all_presensi/bindings/all_presensi_binding.dart';
import '../modules/all_presensi/views/all_presensi_view.dart';
import '../modules/detail_dosen/bindings/detail_dosen_binding.dart';
import '../modules/detail_dosen/views/detail_dosen_view.dart';
import '../modules/detail_jadwal/bindings/detail_jadwal_binding.dart';
import '../modules/detail_jadwal/views/detail_jadwal_view.dart';
import '../modules/detail_mahasiswa/bindings/detail_mahasiswa_binding.dart';
import '../modules/detail_mahasiswa/views/detail_mahasiswa_view.dart';
import '../modules/detail_presensi/bindings/detail_presensi_binding.dart';
import '../modules/detail_presensi/views/detail_presensi_view.dart';
import '../modules/edit_detail_dosen/bindings/edit_detail_dosen_binding.dart';
import '../modules/edit_detail_dosen/views/edit_detail_dosen_view.dart';
import '../modules/edit_detail_mahasiswa/bindings/edit_detail_mahasiswa_binding.dart';
import '../modules/edit_detail_mahasiswa/views/edit_detail_mahasiswa_view.dart';
import '../modules/edit_jadwal/bindings/edit_jadwal_binding.dart';
import '../modules/edit_jadwal/views/edit_jadwal_view.dart';
import '../modules/edit_ruangan/bindings/edit_ruangan_binding.dart';
import '../modules/edit_ruangan/views/edit_ruangan_view.dart';
import '../modules/forget_password/bindings/forget_password_binding.dart';
import '../modules/forget_password/views/forget_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/list_absen_mahasiswa/bindings/list_absen_mahasiswa_binding.dart';
import '../modules/list_absen_mahasiswa/views/list_absen_mahasiswa_view.dart';
import '../modules/list_dosen/bindings/list_dosen_binding.dart';
import '../modules/list_dosen/views/list_dosen_view.dart';
import '../modules/list_jadwal/bindings/list_jadwal_binding.dart';
import '../modules/list_jadwal/views/list_jadwal_view.dart';
import '../modules/list_jadwal_dosen/bindings/list_jadwal_dosen_binding.dart';
import '../modules/list_jadwal_dosen/views/list_jadwal_dosen_view.dart';
import '../modules/list_mahasiswa/bindings/list_mahasiswa_binding.dart';
import '../modules/list_mahasiswa/views/list_mahasiswa_view.dart';
import '../modules/list_ruangan/bindings/list_ruangan_binding.dart';
import '../modules/list_ruangan/views/list_ruangan_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/new_password/bindings/new_password_binding.dart';
import '../modules/new_password/views/new_password_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/update_mahasiswa/bindings/update_mahasiswa_binding.dart';
import '../modules/update_mahasiswa/views/update_mahasiswa_view.dart';
import '../modules/update_password/bindings/update_password_binding.dart';
import '../modules/update_password/views/update_password_view.dart';
import '../modules/update_profile/bindings/update_profile_binding.dart';
import '../modules/update_profile/views/update_profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
        name: _Paths.HOME,
        page: () => HomeView(),
        binding: HomeBinding(),
        transition: Transition.fadeIn),
    GetPage(
      name: _Paths.ADD_PEGAWAI,
      page: () => const AddPegawaiView(),
      binding: AddPegawaiBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.NEW_PASSWORD,
      page: () => const NewPasswordView(),
      binding: NewPasswordBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => const ForgetPasswordView(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
        name: _Paths.PROFILE,
        page: () => ProfileView(),
        binding: ProfileBinding(),
        transition: Transition.fadeIn),
    GetPage(
      name: _Paths.UPDATE_PASSWORD,
      page: () => const UpdatePasswordView(),
      binding: UpdatePasswordBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_PROFILE,
      page: () => const UpdateProfileView(),
      binding: UpdateProfileBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PRESENSI,
      page: () => DetailPresensiView(),
      binding: DetailPresensiBinding(),
    ),
    GetPage(
      name: _Paths.ALL_PRESENSI,
      page: () => const AllPresensiView(),
      binding: AllPresensiBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LIST_MAHASISWA,
      page: () => const ListMahasiswaView(),
      binding: ListMahasiswaBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_MAHASISWA,
      page: () => const UpdateMahasiswaView(),
      binding: UpdateMahasiswaBinding(),
    ),
    GetPage(
      name: _Paths.LIST_ABSEN_MAHASISWA,
      page: () => const ListAbsenMahasiswaView(),
      binding: ListAbsenMahasiswaBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_MAHASISWA,
      page: () => const DetailMahasiswaView(),
      binding: DetailMahasiswaBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_DETAIL_MAHASISWA,
      page: () => const EditDetailMahasiswaView(),
      binding: EditDetailMahasiswaBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_DETAIL_DOSEN,
      page: () => const EditDetailDosenView(),
      binding: EditDetailDosenBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_DOSEN,
      page: () => const DetailDosenView(),
      binding: DetailDosenBinding(),
    ),
    GetPage(
      name: _Paths.LIST_DOSEN,
      page: () => const ListDosenView(),
      binding: ListDosenBinding(),
    ),
    GetPage(
      name: _Paths.ADD_DOSEN,
      page: () => const AddDosenView(),
      binding: AddDosenBinding(),
    ),
    GetPage(
      name: _Paths.ADD_JADWAL,
      page: () => const AddJadwalView(),
      binding: AddJadwalBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_JADWAL,
      page: () => const EditJadwalView(),
      binding: EditJadwalBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_JADWAL,
      page: () => const DetailJadwalView(),
      binding: DetailJadwalBinding(),
    ),
    GetPage(
      name: _Paths.LIST_JADWAL,
      page: () => const ListJadwalView(),
      binding: ListJadwalBinding(),
    ),
    GetPage(
      name: _Paths.ADD_JADWAL_DOSEN,
      page: () => const AddJadwalDosenView(),
      binding: AddJadwalDosenBinding(),
    ),
    GetPage(
      name: _Paths.LIST_JADWAL_DOSEN,
      page: () => const ListJadwalDosenView(),
      binding: ListJadwalDosenBinding(),
    ),
    GetPage(
      name: _Paths.LIST_RUANGAN,
      page: () => const ListRuanganView(),
      binding: ListRuanganBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_RUANGAN,
      page: () => const EditRuanganView(),
      binding: EditRuanganBinding(),
    ),
    GetPage(
      name: _Paths.ADD_RUANGAN,
      page: () => const AddRuanganView(),
      binding: AddRuanganBinding(),
    ),
  ];
}
