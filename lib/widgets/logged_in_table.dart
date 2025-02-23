import 'package:flutter/material.dart';
import '../services/backend_service.dart';
import '../utils/text_utils.dart';
import 'logged_in_row.dart';

class LoggedInTable extends StatefulWidget {
  final Map<String, dynamic> initialData;

  const LoggedInTable({Key? key, required this.initialData}) : super(key: key);

  @override
  LoggedInTableState createState() => LoggedInTableState();
}

class LoggedInTableState extends State<LoggedInTable> {
  int? _selectedRowIndex;
  final List<Map<String, String>> _tableData = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data from backend
  }

  void initializeTable(List<dynamic> logData) {
    setState(() {
      _tableData.clear();
      for (var value in logData) {
        _tableData.add({
          'TP Number': value['tpnumber'] ?? '',
          'Name': value['username'] ?? '',
          'Time': value['login_time'] ?? ''
        });
      }
    });
  }

  Future<void> fetchData() async {
    try {
      final logData = await get_user_log_data();
      debugPrint('Log data fetched: $logData');
      if (logData['status'] == true &&
          logData['data'] != null &&
          logData['data'].isNotEmpty) {
        initializeTable(logData['data']);
      }
    } catch (e) {
      debugPrint('Error fetching log data: $e');
    }
  }

  void addNewRow(String tpNumber, String name, String time) {
    setState(() {
      _tableData.add({'TP Number': tpNumber, 'Name': name, 'Time': time});
    });
  }

  void deleteRow(int index) {
    setState(() {
      _tableData.removeAt(index);
      if (_selectedRowIndex == index) {
        _selectedRowIndex = null;
      } else if (_selectedRowIndex != null && _selectedRowIndex! > index) {
        _selectedRowIndex = _selectedRowIndex! - 1;
      }
    });
  }

  List<String> getFirstColumnValues() {
    return _tableData.map((row) => row['TP Number']!).toList();
  }

  int? get selectedRowIndex => _selectedRowIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 2, 60, 108).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: TextUtil.getTextWidget(
                              'TPNumber', TextStyleType.tableHeading),
                        ),
                      ),
                      VerticalDivider(color: Colors.white),
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: TextUtil.getTextWidget(
                              'Name', TextStyleType.tableHeading),
                        ),
                      ),
                      VerticalDivider(color: Colors.white),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: TextUtil.getTextWidget(
                            'Time',
                            TextStyleType.tableHeading,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _tableData.length,
                    itemBuilder: (context, index) {
                      final row = _tableData[index];
                      return LoggedInRow(
                        index: index,
                        row: row,
                        isSelected: _selectedRowIndex == index,
                        onTap: () {
                          setState(() {
                            _selectedRowIndex = index;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
