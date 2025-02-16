import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'price_view_screen_event.dart';
part 'price_view_screen_state.dart';

class PriceViewScreenBloc extends Bloc<PriceViewScreenEvent, PriceViewScreenState> {
  PriceViewScreenBloc() : super(PriceViewScreenInitial()) {
    on<PriceViewScreenEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
