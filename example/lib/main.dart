import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom Dropdown App',
      home: Home(),
    );
  }
}

const _labelStyle = TextStyle(fontWeight: FontWeight.w600);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class Job {
  String name;
  IconData icon;

  Job(this.name, this.icon);

  @override
  String toString() {
    return '$name';
  }
}

class _HomeState extends State<Home> {
  final formKey = GlobalKey<FormState>();

  final List<Job> list = [
    Job('Developer', Icons.developer_mode),
    Job('Designer', Icons.design_services),
    Job('Consultant', Icons.account_balance),
    Job('Student', Icons.school),
  ];

  final jobRoleDropdownCtrl = TextEditingController(),
      jobRoleFormDropdownCtrl = TextEditingController(),
      jobRoleSearchDropdownCtrl = TextEditingController(),
      jobRoleSearchRequestDropdownCtrl = TextEditingController();

  Future<List<Job>> getFakeRequestData(String query) async {
    return await Future.delayed(const Duration(seconds: 1), () {
      return list.where((e) {
        return e.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    jobRoleDropdownCtrl.dispose();
    jobRoleFormDropdownCtrl.dispose();
    jobRoleSearchDropdownCtrl.dispose();
    jobRoleSearchRequestDropdownCtrl.dispose();
    super.dispose();
  }

  //function to be called with every item how it's gona be sho in the dropdown list
  Widget listItemBuilder(BuildContext context, Job job) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(job.name),
        Icon(job.icon),
      ],
    );
  }

  //function to be called when a item is selected
  Widget selectedHeaderBuilder(BuildContext context, Job job) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(job.name),
      ],
    );
  }

  //function to be called when a item is selected
  Widget hintBuilder(BuildContext context, String hint) {
    return Row(
      children: [
        Text(hint),
        const Icon(Icons.question_mark),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        elevation: .25,
        title: const Text(
          'Custom Dropdown Example',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Job Roles Dropdown', style: _labelStyle),
          const SizedBox(height: 8),
          CustomDropdown<Job>(
            hintText: 'Select job role',
            items: list,
            selectedItem: list[0],
            excludeSelected: false,
            onChanged: (value) {
              print('changing value to: $value');
            },
            listItemBuilder: (context, result) => listItemBuilder(context, result),
            headerBuilder: (context, result) => selectedHeaderBuilder(context, result),
            hintBuilder: (context, result) => hintBuilder(context, result),
          ),
          const SizedBox(height: 24),
          const Divider(height: 0),
          const SizedBox(height: 24),

          // dropdown having search field
          const Text('Job Roles Search Dropdown', style: _labelStyle),
          const SizedBox(height: 8),
          CustomDropdown<Job>.search(
            hintText: 'Select job role',
            items: list,
            onChanged: (value) {
              print('changing value to: $value');
            },
            excludeSelected: false,
            fillColor: Colors.red,
            listItemBuilder: (context, result) => listItemBuilder(context, result),
            headerBuilder: (context, result) => selectedHeaderBuilder(context, result),
          ),
          const SizedBox(height: 24),
          const Divider(height: 0),
          const SizedBox(height: 24),

          // dropdown having search request field (making fake call)
          const Text('Job Roles Search Request Dropdown', style: _labelStyle),
          const SizedBox(height: 8),
          CustomDropdown<Job>.searchRequest(
            futureRequest: getFakeRequestData,
            hintText: 'Search job role',
            items: list,
            onChanged: (value) {
              print('changing value to: $value');
            },
            listItemBuilder: (context, result) => listItemBuilder(context, result),
            headerBuilder: (context, result) => selectedHeaderBuilder(context, result),
            hintBuilder: (context, result) => hintBuilder(context, result),
            futureRequestDelay: const Duration(milliseconds: 150), //it waits 150 ms before start searching (before execute the 'futureRequest' function)
          ),
          const SizedBox(height: 24),
          const Divider(height: 0),
          const SizedBox(height: 24),

          // using form for validation
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Job Roles Dropdown with Form validation',
                  style: _labelStyle,
                ),
                const SizedBox(height: 8),
                CustomDropdown<Job>(
                  hintText: 'Select job role',
                  items: list,
                  excludeSelected: false,
                  onChanged: (value) {
                    print('changing value to: $value');
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
