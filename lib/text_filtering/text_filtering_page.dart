import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_filtering_flutter_sudan/text_filtering/text_filtering_bloc.dart';
import 'package:text_filtering_flutter_sudan/text_filtering/text_filtering_extras.dart';

class TextFiltering extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return TextFilteringState();
  }
}

class TextFilteringState extends State<TextFiltering> {
  
  TextFilteringBloc bloc;
  var width , height;
  var formKey = GlobalKey<FormState>();
  var text = TextEditingController();
  var search = TextEditingController();

  List<TextFilterModel> mainList = List();
  List<TextFilterModel> filteredList = List();



  @override
  void initState() {
    super.initState();
    
    bloc = TextFilteringBloc(Idle());
  }

  @override
  void dispose() {
    super.dispose();
    
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width / 100;
    height = MediaQuery.of(context).size.height / 100;

    return Scaffold(
      appBar: AppBar(
        title: Text('Text Filtering'),
      ),
      body: BlocBuilder(
        cubit: bloc,
        builder: (context , state){

          if(state is TextFiltered){
            mainList = state.textFiltered;
            return screenTwo(textFiltered: mainList);
          }

          if(state is ResetState){
            // text.clear();
            search.clear();
            return screenOne();
          }

          if(state is SearchTextState){

            mainList.forEach((text) {
              if(text.text.contains(state.text)){
                if(!filteredList.contains(text)){
                  print('Added');
                  filteredList.add(text);
                }
                else{
                  print('Not Added');
                }
              }
            });

            return screenTwo(textFiltered: filteredList);
          }

          return screenOne();
        },
      ),
    );
  }

  Widget screenOne(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Welcome Flutter Sudan Members' , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.w600),),
        SizedBox(height: 20,),
        Form(
          key: formKey,
          child: Container(
            height: height * 30,
            width: width * 90,
            decoration: BoxDecoration(
                color: Colors.white,
                border:
                Border.all(color: Color(0xffDCDCDC), width: 2),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15, vertical: 5),
                child: TextFormField(
                  controller: text,
                  maxLines: null,
                  style: TextStyle(
                      color: Color(0xff111719),
                      fontWeight: FontWeight.w600),
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'text is required';
                    }
                    // else{
                    //   if(isNumeric(text)){
                    //     if(text.trim().length != 10){
                    //       return 'mobile number must be 10 numbers';
                    //     }
                    //   }
                    //   else{
                    //     return validateEmail(text);
                    //   }
                    // }
                    return null;
                  },
                  cursorColor: Colors.grey[300],
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type your text here',
                    hintStyle: TextStyle(fontSize: 14),
                    errorStyle: TextStyle(height: .1),
                  ),
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 20,),

        InkWell(
          onTap: () {
            if(formKey.currentState.validate()){
              bloc.add(FilterText(text : text.text.trim()));
            }
          },
          child: Container(
            height: 45,
            margin: EdgeInsets.symmetric(horizontal: width * 5),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                'Filter',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
                maxLines: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget screenTwo({List<TextFilterModel> textFiltered}){
    return Column(
      children: [

        SizedBox(height: 20,),

        Container(
          height: 50,
          width: width * 90,
          decoration: BoxDecoration(
              color: Colors.white,
              border:
              Border.all(color: Color(0xffDCDCDC), width: 2),
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15, vertical: 5),
              child: TextFormField(
                controller: search,
                onChanged: (text){
                  filteredList.clear();
                  bloc.add(SearchText(text: text));
                },
                style: TextStyle(
                    color: Color(0xff111719),
                    fontWeight: FontWeight.w600),
                cursorColor: Colors.grey[300],
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Searh for text here',
                  hintStyle: TextStyle(fontSize: 14),
                  errorStyle: TextStyle(height: .1),
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 20,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Text' , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.w800)),
            Text('Count' , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.w800)),
          ],
        ),

        SizedBox(height: 10,),

        Expanded(
          child: textFiltered.isNotEmpty
              ? ListView.builder(
            itemCount: textFiltered.length,
            itemBuilder: (context , index){
              return Container(
                height:  55,
                width: width * 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xffDCDCDC), width: 2),
                  color: Colors.white
                ),
                margin: EdgeInsets.symmetric(vertical: 10 , horizontal: width * 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('${textFiltered[index].text}'),
                    Text('${textFiltered[index].count}'),
                  ],
                ),
              );
            },
          )
              : Center(
            child: Text('The text you entered does not exist' , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.w600),),
          ),
        ),

        SizedBox(height: 10,),

        InkWell(
          onTap: () {
              bloc.add(Reset());
          },
          child: Container(
            height: 45,
            margin: EdgeInsets.symmetric(horizontal: width * 7),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                'Reset',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
                maxLines: 1,
              ),
            ),
          ),
        ),

        SizedBox(height: 20,),


      ],
    );
  }
}

