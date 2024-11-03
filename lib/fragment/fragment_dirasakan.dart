import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ripple_wave/ripple_wave.dart';

import '../tools/tools.dart';

class FragmentDirasakan extends StatefulWidget {
  const FragmentDirasakan({super.key});

  @override
  State<FragmentDirasakan> createState() => _FragmentDirasakanState();
}

class _FragmentDirasakanState extends State<FragmentDirasakan> {
  List listDataTerkini = [];

  Future getData() async {
    var url =
    Uri.parse('https://data.bmkg.go.id/DataMKG/TEWS/gempadirasakan.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        listDataTerkini = data['Infogempa']['gempa'];
      });
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getData(),
        builder: (context, data) {
          return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: listDataTerkini.length,
              itemBuilder: (context, index) {
                var latlong = listDataTerkini[index]['Coordinates']!.split(',');
                double dlatitude = double.parse(latlong[0]);
                double dlongitude = double.parse(latlong[1]);

                double dJarak = Geolocator.distanceBetween(
                    VariableGlobal.strLatitude,
                    VariableGlobal.strLongitude,
                    dlatitude,
                    dlongitude);
                double distanceInKiloMeters = dJarak / 1000;
                double roundDistanceInKM =
                double.parse((distanceInKiloMeters).toStringAsFixed(2));

                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      isDismissible: false,
                      enableDrag: false,
                      context: context,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20)
                          )
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      builder: (BuildContext context) {
                        return ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Informasi Detail",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Chirp',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    iconSize: 30,
                                    icon: const Icon(Icons.clear),
                                    onPressed: () => Navigator.pop(context),
                                  )
                                ],
                              ),
                            ),
                            Card(
                              margin: const EdgeInsets.all(10),
                              clipBehavior: Clip.antiAlias,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Gempabumi Dirasakan',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'Poppins'),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Image(
                                                  image: AssetImage(
                                                      'assets/images/ic_kedalaman.png'),
                                                  width: 20,
                                                  height: 20,
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.center,
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  listDataTerkini[index]['Magnitude'],
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontFamily: 'Poppins'),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            const Text(
                                              'Magnitudo',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins'),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Image(
                                                  image: AssetImage(
                                                      'assets/images/ic_magnitudo_card.png'),
                                                  width: 20,
                                                  height: 20,
                                                  fit: BoxFit.scaleDown,
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  listDataTerkini[index]['Kedalaman'],
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontFamily: 'Poppins'),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            const Text(
                                              'Kedalaman',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins'),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Image(
                                                  image: AssetImage(
                                                      'assets/images/ic_location.png'),
                                                  width: 16,
                                                  height: 16,
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.center,
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  listDataTerkini[index]['Lintang'],
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontFamily: 'Poppins'),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              listDataTerkini[index]['Bujur'],
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins'),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              margin: const EdgeInsets.all(10),
                              clipBehavior: Clip.antiAlias,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    ListTile(
                                      dense: true,
                                      visualDensity: const VisualDensity(
                                          horizontal: 0, vertical: -4
                                      ),
                                      leading: const Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.access_time,
                                              color: Colors.redAccent),
                                        ],
                                      ),
                                      title: const Text(
                                        'Waktu',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Poppins'),
                                      ),
                                      subtitle: Text(
                                          SetTime.setTime(listDataTerkini[index]['DateTime']),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontFamily: 'Poppins')),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ListTile(
                                      dense: true,
                                      visualDensity: const VisualDensity(
                                          horizontal: 0, vertical: -4
                                      ),
                                      leading: const Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.adjust_rounded,
                                              color: Colors.redAccent),
                                        ],
                                      ),
                                      title: const Text(
                                        'Wilayah Dirasakan',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Poppins'),
                                      ),
                                      subtitle: Text(listDataTerkini[index]['Dirasakan'],
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontFamily: 'Poppins')),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ListTile(
                                      dense: true,
                                      visualDensity: const VisualDensity(
                                          horizontal: 0, vertical: -4
                                      ),
                                      leading: const Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.my_location,
                                              color: Colors.redAccent),
                                        ],
                                      ),
                                      title: const Text(
                                        'Lokasi Gempa',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Poppins'),
                                      ),
                                      subtitle: Text(listDataTerkini[index]['Wilayah'],
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontFamily: 'Poppins')),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ListTile(
                                      dense: true,
                                      visualDensity: const VisualDensity(
                                          horizontal: 0, vertical: -4
                                      ),
                                      leading: const Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.compare_arrows,
                                              color: Colors.redAccent),
                                        ],
                                      ),
                                      title: const Text(
                                        'Jarak',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Poppins'),
                                      ),
                                      subtitle: Text(
                                          '${roundDistanceInKM.round()} KM dari ${VariableGlobal.strAlamat}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontFamily: 'Poppins')),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    clipBehavior: Clip.antiAlias,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: double.parse(listDataTerkini[index]['Magnitude']) >= 6 ? Colors.redAccent : Colors.lightBlue,
                              width: 5,
                            ),
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            ListTile(
                              isThreeLine: true,
                              contentPadding: EdgeInsets.zero,
                              leading: SizedBox(
                                  width: 90,
                                  height: double.infinity,
                                  child: Stack(
                                    children: [
                                      RippleWave(
                                        color: double.parse(listDataTerkini[index]['Magnitude']) >= 6 ? Colors.redAccent : Colors.lightBlue,
                                        repeat: true,
                                        child: const SizedBox(),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          listDataTerkini[index]['Magnitude'],
                                          style: TextStyle(
                                              color: double.parse(listDataTerkini[index]['Magnitude']) >= 6 ? Colors.redAccent : Colors.lightBlue,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Poppins'),
                                        ),
                                      ),
                                    ],
                                  )),
                              title: Text(
                                listDataTerkini[index]['Wilayah'],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Poppins'),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time,
                                          color: Colors.redAccent, size: 16),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                            SetTime.setTime(listDataTerkini[index]
                                            ['DateTime']),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                fontFamily: 'Poppins')),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.compare_arrows,
                                          color: Colors.redAccent, size: 16),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                            '${roundDistanceInKM.round()} KM dari ${VariableGlobal.strAlamat}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                fontFamily: 'Poppins')),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: const SizedBox(
                                  height: double.infinity,
                                  child: Icon(Icons.keyboard_arrow_right_outlined)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
