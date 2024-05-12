import "dart:async";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:dio/dio.dart";
import "package:get_storage/get_storage.dart";

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  List<TeamMember> teamMembers = [];
  final myStorage = GetStorage();
  static const String _apiUrl = "https://mobileapis.manpits.xyz/api/anggota";

  @override
  void initState() {
    super.initState();
    fetchTeamMembers();
  }

  Future<void> fetchTeamMembers() async {
    try {
      Response response = await Dio().get('$_apiUrl',
          options: Options(
              headers: {"Authorization": "Bearer ${myStorage.read("token")}"}));
      if (response.statusCode == 200) {
        final List<dynamic> anggotas = response.data['data']['anggotas'];

        setState(() {
          teamMembers =
              anggotas.map((member) => TeamMember.fromJson(member)).toList();
        });
      } else {
        throw Exception('Gagal mengambil data dari API');
      }
    } catch (error) {
      print('Error: $error');
      // Tambahkan penanganan error sesuai kebutuhan Anda
    }
  }

  void _deleteMember(int memberId) async {
    try {
      Response response = await Dio().delete('$_apiUrl/$memberId',
          options: Options(
              headers: {"Authorization": "Bearer ${myStorage.read("token")}"}));
      setState(() {
        teamMembers.removeWhere((member) => member.id == memberId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anggota tim berhasil dihapus'),
        ),
      );
    } catch (error) {
      print('Error saat menghapus anggota: $error');
      // Tampilkan pesan kesalahan atau lakukan penanganan kesalahan lainnya
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menghapus anggota tim'),
        ),
      );
    }
  }

  void _showMemberDetail(TeamMember member) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Member Detail',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildDetailRow('ID', member.id.toString()),
                _buildDetailRow('Nomer Induk', member.nomorInduk.toString()),
                _buildDetailRow('Nama', member.nama),
                _buildDetailRow('Alamat', member.alamat),
                _buildDetailRow('Tanggal Lahir', member.tanggalLahir),
                _buildDetailRow('Telepon', member.telepon),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EditMemberButton(members: member),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label + ':',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          teamMembers.isEmpty
              ? const Center(
                  child: Text("Belum ada anggota tim",
                      style: TextStyle(fontSize: 20, color: Colors.white38)),
                )
              : ListView.builder(
                  itemCount: teamMembers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          leading:
                              const Icon(Icons.person, color: Colors.black),
                          title: Text(
                            teamMembers[index].nama,
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () => _showMemberDetail(teamMembers[index]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _deleteMember(teamMembers[index].id);
                                  // Implementasi fungsi hapus di sini
                                },
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
          AddMemberButton(),
        ],
      ),
    );
  }
}

class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    required this.hint,
    required this.textController,
  });

  final String hint;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hint,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromARGB(255, 154, 210, 2), width: 2),
        ),
      ),
    );
  }
}

class EditMemberButton extends StatefulWidget {
  EditMemberButton({
    super.key,
    required this.members,
  });

  final TeamMember members;

  @override
  State<EditMemberButton> createState() => _EditMemberButtonState();
}

class _EditMemberButtonState extends State<EditMemberButton> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final String _apiUrl = "https://mobileapis.manpits.xyz/api/anggota";
  DateTime? selectedDate;

  final myStorage = GetStorage();

  void editMember(context) async {
    try {
      final response = await Dio().put("$_apiUrl/${widget.members.id}",
          data: {
            "nomor_induk": idController.text,
            "nama": nameController.text,
            "alamat": addressController.text,
            "telepon": telephoneController.text,
            "tgl_lahir": selectedDate.toString(),
            "status_aktif": "1",
          },
          options: Options(
            headers: {
              "Authorization": "Bearer ${myStorage.read("token")}",
            },
          ));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anggota tim berhasil diupdate'),
          ),
        );
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/homePage');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal update anggota tim'),
          ),
        );
        Navigator.pop(context);
      }
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal update anggota tim'),
        ),
      );
      Navigator.pop(context);
      print('Error: $e');
    }
  }

  void editMemberDialog(BuildContext context) {
    idController.text = widget.members.nomorInduk.toString();
    nameController.text = widget.members.nama;
    addressController.text = widget.members.alamat;
    addressController.text = widget.members.telepon;
    telephoneController.text = widget.members.telepon;
    selectedDate = DateTime.parse(widget.members.tanggalLahir);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 550,
            width: 350,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 20,
                right: 20,
                left: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Edit Team Member",
                    style: TextStyle(
                      fontSize: 18,
                      color:
                          Color.fromARGB(255, 154, 210, 2), // Warna yang diubah
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextInput(hint: "ID Number", textController: idController),
                  TextInput(hint: "Name", textController: nameController),
                  TextInput(hint: "Address", textController: addressController),
                  TextInput(
                      hint: "Telephone", textController: telephoneController),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Date of Birth"),
                      ElevatedButton(
                        onPressed: () async {
                          final DateTime? dateTime = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2050),
                          );
                          if (dateTime != null) {
                            setState(() {
                              selectedDate = dateTime;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            side: BorderSide(color: Colors.black),
                          ),
                        ),
                        child: const Text("Pick a Date"),
                      )
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      editMember(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color.fromARGB(255, 154, 210, 2), // Warna yang diubah
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.only(bottom: 20),
      child: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 239, 152, 3),
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
        onPressed: () {
          editMemberDialog(context);
        },
      ),
    );
  }
}

class AddMemberButton extends StatefulWidget {
  AddMemberButton({super.key});

  @override
  State<AddMemberButton> createState() => _AddMemberButtonState();
}

class _AddMemberButtonState extends State<AddMemberButton> {
  final String _apiUrl = "https://mobileapis.manpits.xyz/api/anggota";

  final myStorage = GetStorage();

  final TextEditingController idController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController telephoneController = TextEditingController();
  DateTime? selectedDate;

  void postMember(context) async {
    try {
      final response = await Dio().post(_apiUrl,
          data: {
            "nomor_induk": idController.text,
            "nama": nameController.text,
            "alamat": addressController.text,
            "telepon": telephoneController.text,
            "tgl_lahir": selectedDate.toString(),
          },
          options: Options(
            headers: {
              "Authorization": "Bearer ${myStorage.read("token")}",
            },
          ));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anggota tim berhasil ditambahkan'),
          ),
        );
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/homePage');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menambahkan anggota tim'),
          ),
        );
        Navigator.pop(context);
      }
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menambahkan anggota tim'),
        ),
      );
      Navigator.pop(context);
      print('Error: $e');
    }
  }

  void addMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 550,
            width: 350,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 20,
                right: 20,
                left: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "New Team Member",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 154, 210, 2),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextInput(hint: "ID Number", textController: idController),
                  TextInput(hint: "Name", textController: nameController),
                  TextInput(hint: "Address", textController: addressController),
                  TextInput(
                      hint: "Telephone", textController: telephoneController),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Date of Birth"),
                      ElevatedButton(
                        onPressed: () async {
                          final DateTime? dateTime = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2050),
                          );
                          if (dateTime != null) {
                            setState(() {
                              // Lakukan sesuatu dengan tanggal yang dipilih, misalnya menyimpannya ke dalam variabel atau menampilkan di layar
                              print('Selected date: $dateTime');
                              selectedDate = dateTime;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            side: BorderSide(color: Colors.black),
                          ),
                        ),
                        child: Text(selectedDate != null
                            ? selectedDate.toString()
                            : "Pick a Date"),
                      )
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      postMember(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 154, 210, 2),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    child: const Text(
                      "Save Member",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.only(bottom: 20),
      child: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(215, 252, 112, 1),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () {
          addMemberDialog(context);
        },
      ),
    );
  }
}

class TeamMember {
  final int id;
  final int nomorInduk;
  final String nama;
  final String alamat;
  final String tanggalLahir;
  final String telepon;
  final String imageUrl;
  final int statusAktif;

  TeamMember({
    required this.id,
    required this.nomorInduk,
    required this.nama,
    required this.alamat,
    required this.tanggalLahir,
    required this.telepon,
    required this.imageUrl,
    required this.statusAktif,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'],
      nomorInduk: json['nomor_induk'],
      nama: json['nama'],
      alamat: json['alamat'],
      tanggalLahir: json['tgl_lahir'],
      telepon: json['telepon'],
      imageUrl:
          json['image_url'] ?? '', // Jika image_url null, gunakan string kosong
      statusAktif: json['status_aktif'],
    );
  }
}
