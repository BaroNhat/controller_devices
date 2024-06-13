// lib/light_detail_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';

class LightDetailPage extends StatefulWidget {
  const LightDetailPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LightDetailPageState createState() => _LightDetailPageState();
}

class _LightDetailPageState extends State<LightDetailPage> {
  double _brightness = 128; // Giá trị độ sáng ban đầu
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  bool _isLoading = true; // Biến trạng thái để kiểm tra xem dữ liệu đã được tải hay chưa

  @override
  void initState() {
    super.initState();
    // Lắng nghe sự thay đổi ở nút 'Light Value'
    _databaseReference.child('Light Value').onValue.listen((event) {
      setState(() {
        // Đảm bảo giá trị là double, mặc định là giá trị hiện tại nếu null
        _brightness = (event.snapshot.value as num?)?.toDouble() ?? _brightness;
        _isLoading = false; // Đánh dấu là đã tải xong dữ liệu
      });
    });
  }

  void _updateBrightness(double value) {
    setState(() {
      _brightness = value;
    });
    // Cập nhật giá trị 'Light Value' trong cơ sở dữ liệu
    _databaseReference.update({'Light Value': _brightness.round()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Light Details'),
        backgroundColor: Colors.grey[300],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Hiển thị trạng thái tải
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Adjust LIGHT Brightness',
              style: GoogleFonts.bebasNeue(fontSize: 35),
            ),
            const SizedBox(height: 40),
            Slider(
              value: _brightness,
              min: 0,
              max: 255,
              divisions: 255,
              label: _brightness.round().toString(),
              onChanged: _updateBrightness,
            ),
            const SizedBox(height: 20),
            Text(
              'Brightness: ${_brightness.round()}',
              style: GoogleFonts.bebasNeue(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
