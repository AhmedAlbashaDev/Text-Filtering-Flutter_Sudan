import 'dart:async';
import 'package:bloc/bloc.dart';
import 'text_filtering_extras.dart';

class TextFilteringBloc extends Bloc<TextFilteringEvent, TextFilteringState> {
  TextFilteringBloc(TextFilteringState initialState) : super(initialState);

  TextFilteringState get initialState => TextFilteringState();

  @override
  Stream<TextFilteringState> mapEventToState(TextFilteringEvent event) async* {
    if (event is FilterText) {

      List<TextFilterModel> textList = List();
      List<TextFilterModel> textFiltered = List();

      var arrayOfText = event.text.split(' ');

      arrayOfText.forEach((text) {
        textFiltered.add(TextFilterModel(text: text, count: 1));
      });

      textFiltered.forEach((text) {
        if (textList.isNotEmpty) {

          final textFound = textList.firstWhere((element) => element.text == text.text, orElse: () => null);

          if (textFound != null) {
            textFound.count++;
          } else {
            textList.add(TextFilterModel(text: text.text, count: 1));
          }

        } else {
          textList.add(TextFilterModel(text: text.text, count: 1));
        }

      });

      yield TextFiltered(textFiltered: textList);

    }

    if (event is Reset) {
      yield ResetState();
    }

    if (event is SearchText) {
      yield SearchTextState(text: event.text);
    }
  }
}

class TextFilterModel {
  String text;
  int count;

  TextFilterModel({this.text, this.count});
}
