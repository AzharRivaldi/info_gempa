import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:info_gempa/model/model_terkini.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../tools/tools.dart';

class FragmentTerkini extends StatefulWidget {
  const FragmentTerkini({super.key});

  @override
  State<FragmentTerkini> createState() => _FragmentTerkiniState();
}

class _FragmentTerkiniState extends State<FragmentTerkini> {
  String strLatLong = 'Belum Mendapatkan Lat dan Long';
  String strAlamat = 'Mencari lokasi...';
  double latitude = 0;
  double longitude = 0;

  @override
  initState() {
    getData();
    super.initState();
    initializeDateFormatting();
  }

  Future getData() async {
    Position position = await getGeoLocationPosition();
    setState(() {
      VariableGlobal.strLatitude = position.latitude;
      VariableGlobal.strLongitude = position.longitude;
      strLatLong = '${position.latitude}, ${position.longitude}';
    });

    getAddressFromLongLat(position);
  }

  //getLatLong
  Future<Position> getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service Not Enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permission denied forever, we cannot access',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  //getAddress
  Future<void> getAddressFromLongLat(Position position) async {
    latitude = position.latitude;
    longitude = position.longitude;

    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];
    setState(() {
      strAlamat = '${place.subLocality}';
      VariableGlobal.strAlamat = strAlamat;
    });
  }

  Future getDataTerkini() async {
    var url = Uri.parse('https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['Infogempa'];
      return ModelTerkini.fromJson(data);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/image_gempa_terkini.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder(
          future: getDataTerkini(),
          builder: (context, data) {
            if (data.hasError) {
              return Center(child: Text("${data.error}"));
            } else if (data.hasData) {
              var items = data.data as ModelTerkini;

              var latlong = items.strCoordinates!.split(',');
              double dlatitude = double.parse(latlong[0]);
              double dlongitude = double.parse(latlong[1]);

              double dJarak = Geolocator.distanceBetween(latitude, longitude, dlatitude, dlongitude);
              double distanceInKiloMeters = dJarak / 1000;
              double roundDistanceInKM = double.parse((distanceInKiloMeters).toStringAsFixed(2));

              return ListView(
                children: [
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
                                        items.strMagnitude.toString(),
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
                                        items.strKedalaman.toString(),
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
                                        items.strLintang.toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontFamily: 'Poppins'),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    items.strBujur.toString(),
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
                                SetTime.setTime(items.strDateTime.toString()),
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
                            subtitle: Text(items.strDirasakan.toString(),
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
                            subtitle: Text(items.strWilayah.toString(),
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
                                horizontal: 0, vertical: -4)
                            ,
                            leading: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.share_location_sharp,
                                    color: Colors.redAccent),
                              ],
                            ),
                            title: const Text(
                              'Potensi',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Poppins'),
                            ),
                            subtitle: Text(items.strPotensi.toString(),
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
                                '${roundDistanceInKM.round()} KM dari $strAlamat',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Poppins')),
                          ),
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
                      padding: const EdgeInsets.all(20),
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: size.width,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green),
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)
                                    )
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                builder: (BuildContext context) {
                                  return InteractiveViewer(
                                    child: Image.network(
                                      'https://data.bmkg.go.id/DataMKG/TEWS/${items.strShakemap}',
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                    ),
                                  );
                                },
                              );
                            },
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.transparent,
                              child: const Center(
                                child: Text(
                                  'Lihat Peta Guncangan',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
