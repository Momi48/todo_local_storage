import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void saveData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setStringList('todolist', todolist);
    sp.setStringList('desclist', description);
    
    print('Save Data in todolist is $todolist');
    print('Save Data in Description $description');
    setState(() {});
  }

  void loadData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    todolist = sp.getStringList('todolist') ?? [];
    description = sp.getStringList('desclist') ?? [];
    print('Loaded Data in todolist is $todolist');
    print('Loaded Data in Description $description');
    setState(() {});
  }
void removeData() async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  print('Cache is Clear ');
 sp.clear();
}
  List<String> todolist = [];
  List<String> description = [];
 List <bool> isSelected = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController editTitleController = TextEditingController();
  TextEditingController editDesController = TextEditingController();
 
  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo Task'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            removeData();
          }, icon: const Icon(Icons.cached))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: todolist.length,
                itemBuilder: (context, index) {
                  //initialze it or assign the values again 
                   isSelected.add(false);
                  return ListTile(
                    leading: IconButton(
                      onPressed: () {
                        setState(() {
                          isSelected[index] = !isSelected[index];
                          
                        });
                      },
                      icon: isSelected[index] ? const Icon(
                              Icons.check_box,
                              color: Colors.green,
                            )
                          : const Icon(Icons.close,color: Colors.red,)
                    ),
                    title: Text(todolist[index]),
                    subtitle: Text(description[index]),
                    trailing: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                delete(index);
                                saveData();
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 25,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                editItem(index);
                              });
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.red,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          enterTask();
        },
        backgroundColor: Colors.blue,
        tooltip: 'Add Titlte and Description of your Task',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      
    );
  }

  void enterTask() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter Your Title',
                ),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Enter Your Description',
                ),
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      //the title field and the description field to be filled in
                      //if its empty it wont be added 
                      if (titleController.text.isNotEmpty &&
                          descriptionController.text.isNotEmpty) {
                        todolist.add(titleController.text);
                        description.add(descriptionController.text);
                         saveData();
                      }
                  
                      titleController.clear();
                      descriptionController.clear();
                    });
                  
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add ')),
              TextButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
            ],
          );
        });
  }

  void delete(int index) {
    todolist.removeAt(index);
    description.removeAt(index);
  }

  void editItem(int index) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              TextFormField(
                controller: editTitleController,
                decoration: const InputDecoration(
                  hintText: 'Edit Your Title',
                ),
              ),
              TextFormField(
                controller: editDesController,
                decoration: const InputDecoration(
                  hintText: 'Edit Your Description',
                ),
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      todolist[index] = editTitleController.text;
                      todolist[index] = editDesController.text;
                    });
                    saveData();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Edit ')),
              TextButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
            ],
          );
        });
  }
}
