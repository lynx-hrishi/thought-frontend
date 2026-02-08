import "package:flutter/material.dart";
import 'components/textfieldComponent.dart';

class UserDetailsAndPreferences extends StatefulWidget {
  const UserDetailsAndPreferences({super.key});

  @override
  State<UserDetailsAndPreferences> createState() => _UserDetailsAndPreferencesState();
}

class _UserDetailsAndPreferencesState extends State<UserDetailsAndPreferences> {
  final PageController _controller = PageController();

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String gender = '';
  TextEditingController preferenceController = TextEditingController();

  void next(){
    _controller.nextPage(
      duration: const Duration(milliseconds: 300), 
      curve: Curves.easeInOut
    );
  }

  void back(){
    _controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Details and Preferences"),
      ),
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          namePage(),
          agePage(),
          genderPage(),
          preferencePage()
        ],
      ),
    );
  }

  Widget pageWrapper({ required Widget child, bool isLastPage = false, bool isFirstPage = false }){
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          child,
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isFirstPage ? const SizedBox(width: 0,) : TextButton(onPressed: back, child: const Text("Back")),
              !isLastPage ?
               ElevatedButton(onPressed: next, child: const Text("Next")) :
               ElevatedButton(onPressed: (){ print("Name: ${nameController.text}, Age: ${ageController.text}, Gender: $gender, Pref: ${preferenceController.text}"); }, child: const Text("Submit"))
            ],
          )
        ],
      ),
    );
  }

  Widget namePage(){
    return pageWrapper(
      isLastPage: false,
      isFirstPage: true,
      child: customTextField("Name", nameController, (v) => nameController.text = v, false)
    );
  }

  Widget agePage(){
    return pageWrapper(
      isLastPage: false,
      child: customTextField("Age", ageController, (v) => ageController.text = v, false)
    );
  }

  Widget genderPage(){
    return pageWrapper(
      isLastPage: false,
      child: Column(
        children: [
          RadioListTile(
            value: "male",
            title: const Text("MALE"),
            groupValue: gender,
            onChanged: (value) => setState(() => gender = value!),
          ),
          RadioListTile(
            value: "female",
            title: Text("FEMALE"),
            groupValue: gender,
            onChanged: (value) => setState(() => gender = value!),
          )
        ],
      )
    );
  }

  Widget preferencePage(){
    return pageWrapper(
      isLastPage: true,
      child: Column(
        children: [
          customTextField(
            "Preference", 
            preferenceController,
            (v) => preferenceController.text = v, 
            false
          ),
        ],
      )
    );
  }
}