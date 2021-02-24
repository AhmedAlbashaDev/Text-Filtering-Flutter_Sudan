
import 'package:text_filtering_flutter_sudan/text_filtering/text_filtering_bloc.dart';

class TextFilteringEvent {}

class FilterText extends TextFilteringEvent {
  String text;
  FilterText({this.text});
}

class SearchText extends TextFilteringEvent{
  String text;
  SearchText({this.text});
}

class Reset extends TextFilteringEvent{}

class TextFilteringState {}

class Idle extends TextFilteringState {}

class TextFiltered extends TextFilteringState {
  List<TextFilterModel> textFiltered;
  TextFiltered({this.textFiltered});
}

class ResetState extends TextFilteringState {}

class SearchTextState extends TextFilteringState{
  String text;
  SearchTextState({this.text});
}