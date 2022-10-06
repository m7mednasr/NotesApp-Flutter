import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/AppCubit/cubit.dart';


List<String> titles = [
  "Today's planning",
  "Tasks",
  "Done Tasks",
  "Archived Tasks"
];
Widget defultformfield(
        {required TextEditingController? controller,
        required FormFieldValidator<String>? validate,
        required String? name,
        required IconData? iconData,
        required VoidCallback? ontap,
        required TextInputType? type}) =>
    TextFormField(
        onTap: ontap,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(17.0),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(),
          ),
          labelText: name,
          prefix: Icon(iconData),
        ),
        controller: controller,
        keyboardType: type,
        validator: validate);

Widget notesshow(Map module, BuildContext context) => Dismissible(
      key: Key(module['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deletedata(id: module['id']);
      },
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          customButton: Card(
            color: const Color.fromARGB(255, 235, 240, 240),
            child: GridTile(
              header: Text(
                '${module['time']}',
                style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500),
              ),
              footer: Text(
                '${module['date']}',
                textAlign: TextAlign.end,
                style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500),
              ),
              child: Center(
                child: Text(
                  '${module['title']}',
                  style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          openWithLongPress: true,
          customItemsHeights: [
            ...List<double>.filled(MenuItems.firstItems.length, 40),
            4,
            ...List<double>.filled(MenuItems.secondItems.length, 40),
          ],
          items: [
            ...MenuItems.firstItems.map(
              (item) => DropdownMenuItem<MenuItem>(
                value: item,
                child: MenuItems.buildItem(item),
              ),
            ),
            const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
            ...MenuItems.secondItems.map(
              (item) => DropdownMenuItem<MenuItem>(
                value: item,
                child: MenuItems.buildItem(item),
              ),
            ),
          ],
          onChanged: (value) {
            MenuItems.onChanged(context, value as MenuItem, module);
          },
          itemHeight: 30,
          itemPadding: const EdgeInsets.only(left: 16, right: 16),
          dropdownWidth: 140,
          dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color.fromARGB(255, 94, 91, 91),
          ),
          dropdownElevation: 8,
          offset: const Offset(40, -4),
        ),
      ),
    );

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [delete, done];
  static const List<MenuItem> secondItems = [archive];

  static const delete = MenuItem(text: 'Delete', icon: Icons.delete);
  static const done = MenuItem(text: 'Done', icon: Icons.done);
  static const archive = MenuItem(text: 'Archive', icon: Icons.archive);

  static onChanged(
    BuildContext context,
    MenuItem item,
    Map module,
  ) {
    switch (item) {
      case MenuItems.delete:
        {
          return AppCubit.get(context).deletedata(id: module['id']);
        }

      case MenuItems.done:
        {
          return AppCubit.get(context)
              .updatedata(status: 'Done', id: module['id']);
        }
      case MenuItems.archive:
        {
          return AppCubit.get(context)
              .updatedata(status: 'Archived', id: module['id']);
        }
    }
  }

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(
          item.icon,
          color: Colors.white,
          size: 17,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

Widget planBuilder({required List<Map> plan}) => ConditionalBuilder(
      condition: plan.isNotEmpty,
      builder: (context) => SizedBox(
        height: 400,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: plan.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (BuildContext context, int index) {
              return notesshow(plan[index], context);
            },
          ),
        ),
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              height: 40.0,
            ),
            Icon(
              Icons.tips_and_updates_outlined,
              size: 100.0,
              
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              "No Plans add Yet , please add Some Plans.......",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
