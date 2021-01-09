import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'NotesPage.dart';

class NotesPage extends StatefulWidget {
  // NotesPage({Key key}) : super(key: key);
  FirebaseAuth auth;
  User user;
  // Student(this.auth,this.user, {Key key}): super(key: key);
  NotesPage({Key key, @required this.auth,this.user}) : super(key: key);
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  var _formKey = GlobalKey<FormState>();
  var total_notes=0;

  final databaseReference = FirebaseDatabase.instance.reference();
  // total_notes=databaseReference.child("users/${widget.user.uid}/notes/")
  Future<bool> getnotes_length() async{
    // print(widget.user.uid);
    var snapshot = await databaseReference.child("users/${widget.user.uid}/notes/");
    snapshot.once().then((DataSnapshot snapshot){
      // print(snapshot.value);
      total_notes  = snapshot.value.length;
      if(total_notes==0){
        total_notes=1;
      }
    });
    return true;
  }
  @override
  void initState() {
    super.initState();
    notesDescriptionMaxLenth =
        notesDescriptionMaxLines * notesDescriptionMaxLines;
  }

  @override
  void dispose() {
    noteDescriptionController.dispose();
    noteHeadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: notesHeader(),
      ),
      body: buildNotes(),
      floatingActionButton: FloatingActionButton(
        mini: false,
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          _settingModalBottomSheet(context);
        },
        child: Icon(Icons.create),
      ),
    );
  }

  Widget buildNotes() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      child: new StreamBuilder(
        stream: databaseReference.child("users/${widget.user.uid}/notes/").onValue,
        builder: (context, snap) {
          print("IDDDDD");
          print(widget.user.uid);
          if (snap.hasData &&
              !snap.hasError &&
              snap.data.snapshot.value != null) {
            // print(snap.data.snapshot.value);
            Map data = snap.data.snapshot.value;
            print(data);
            List item = [];

            // data.forEach(
            //         (index, data) => item.add({"key": index, ...data}));
            print("Recorddddd00");
            // print(data['Semester 1']);
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, int index) {
                String key = data.keys.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5.5),
                  child: new Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) {
                      setState(() {
                        databaseReference.child("users/${widget.user.uid}/notes/${key}").remove();
                        // deletedNoteHeading = noteHeading[index];
                        // deletedNoteDescription = noteDescription[index];
                        // noteHeading.removeAt(index);
                        // noteDescription.removeAt(index);
                        // Scaffold.of(context).showSnackBar(
                        //   new SnackBar(
                        //     backgroundColor: Colors.purple,
                        //     content: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         new Text(
                        //           "Note Deleted",
                        //           style: TextStyle(),
                        //         ),
                        //         deletedNoteHeading != ""
                        //             ? GestureDetector(
                        //           onTap: () {
                        //             print("undo");
                        //             setState(() {
                        //               if (deletedNoteHeading != "") {
                        //                 noteHeading.add(deletedNoteHeading);
                        //                 noteDescription
                        //                     .add(deletedNoteDescription);
                        //               }
                        //               deletedNoteHeading = "";
                        //               deletedNoteDescription = "";
                        //             });
                        //           },
                        //           child: new Text(
                        //             "Undo",
                        //             style: TextStyle(),
                        //           ),
                        //         )
                        //             : SizedBox(),
                        //       ],
                        //     ),
                        //   ),
                        // );
                      });
                    },
                    background: ClipRRect(
                      borderRadius: BorderRadius.circular(5.5),
                      child: Container(
                        color: Colors.green,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    secondaryBackground: ClipRRect(
                      borderRadius: BorderRadius.circular(5.5),
                      child: Container(
                        color: Colors.red,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    child: noteList(data[key]["title"],data[key]["description"],index),
                  ),
                );
              },
            );
          } else
            return Center(child: Text("No data"));
        },
      ),

    );
  }

  Widget noteList(String title,String desc,int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.5),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: noteColor[(index % noteColor.length).floor()],
          borderRadius: BorderRadius.circular(5.5),
        ),
        height: 100,
        child: Center(
          child: Row(
            children: [
              new Container(
                color:
                    noteMarginColor[(index % noteMarginColor.length).floor()],
                width: 3.5,
                height: double.infinity,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20.00,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.5,
                      ),
                      Flexible(
                        child: Container(
                          height: double.infinity,
                          child: AutoSizeText(
                            "${(desc)}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15.00,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    // print
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 50,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext bc) {
        return Padding(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: (MediaQuery.of(context).size.height),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 250, top: 50),
                  child: new Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "New Note",
                            style: TextStyle(
                              fontSize: 20.00,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  getnotes_length();
                                  print(total_notes);
                                  databaseReference.child("users/${widget.user.uid}/notes/${"id_"+total_notes.toString()}")
                                      .update({
                                    "title": noteHeadingController.text,
                                    "description":noteDescriptionController.text
                                  });
                                  noteHeadingController.clear();
                                  noteDescriptionController.clear();
                                });
                                Navigator.pop(context);
                              }
                              print("Notes.dart LineNo:239");
                              print(noteHeadingController.text);
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Text(
                                    "Save",
                                    style: TextStyle(
                                      fontSize: 20.00,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.blueAccent,
                        thickness: 2.5,
                      ),
                      TextFormField(
                        maxLength: notesHeaderMaxLenth,
                        controller: noteHeadingController,
                        decoration: InputDecoration(
                          hintText: "Note Heading",
                          hintStyle: TextStyle(
                            fontSize: 15.00,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                        validator: (String noteHeading) {
                          if (noteHeading.isEmpty) {
                            return "Please enter Note Heading";
                          } else if (noteHeading.startsWith(" ")) {
                            return "Please avoid whitespaces";
                          }
                        },
                        onFieldSubmitted: (String value) {
                          FocusScope.of(context)
                              .requestFocus(textSecondFocusNode);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Container(
                          margin: EdgeInsets.all(1),
                          height: 5 * 24.0,
                          child: TextFormField(
                            focusNode: textSecondFocusNode,
                            maxLines: notesDescriptionMaxLines,
                            maxLength: notesDescriptionMaxLenth,
                            controller: noteDescriptionController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Description',
                              hintStyle: TextStyle(
                                fontSize: 15.00,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            validator: (String noteDescription) {
                              if (noteDescription.isEmpty) {
                                return "Please enter Note Desc";
                              } else if (noteDescription.startsWith(" ")) {
                                return "Please avoid whitespaces";
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget notesHeader() {
  return Padding(
    padding: const EdgeInsets.only(
      top: 10,
      left: 2.5,
      right: 2.5,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "My Notes",
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 25.00,
            fontWeight: FontWeight.w500,
          ),
        ),
        Divider(
          color: Colors.blueAccent,
          thickness: 2.5,
        ),
      ],
    ),
  );
}


//
//
// ListView.builder(
// // padding: EdgeInsets.symmetric(horizontal: 50),
// itemCount: data.length,
// itemBuilder: (context, index) {
// return Column(
//
// children:[
// index>0?SizedBox(height: 20,):SizedBox(height: 0,),
// Text("Semester ${index+1}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold), ),
// SingleChildScrollView(
//
// child: DataTable(
// horizontalMargin: 5,
// // columnSpacing: 500,
// showBottomBorder: true,
// dividerThickness: 1,
// headingRowColor:
// MaterialStateColor.resolveWith((states) => Colors.blue),
// showCheckboxColumn: false,
// columns: [
// // DataColumn(label: Text(
// //     'Code',
// //     style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
// // )),
// DataColumn(label: Text(
// 'Name',
// style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
// )),
// DataColumn(label: Text(
// 'Credit',
// style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
// textAlign: TextAlign.center,
// )),
// DataColumn(
//
// label: Text(
// 'Marks',
// style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
// textAlign: TextAlign.center,
// )),
// DataColumn(
// label: Text(
// 'GP',
// style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
// textAlign: TextAlign.center,
// )),
// ],
// rows: List.generate(
// data['Semester ${index+1}'].length-1, (index_) => _getDataRow(data['Semester ${index+1}'][index_])),
// ),
// scrollDirection: my_axis.Axis.horizontal,
//
// ),
//
// Text("CGPA: ${data['Semester ${index+1}'].last['CGPA']}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
// ]
// );
// },
// ),










