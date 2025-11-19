import 'dart:convert';
import 'dart:developer' as developer;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import '../../Constants/ApiConstants.dart';
import '../../utils/pref_utils.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitialState()) {

    on<GetAllProductEventHandler>((event, emit) async {
      emit(ProductLoadingState());
      try {
        final userToken = PrefUtils.getToken();

        // Build query parameters dynamically
        final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.getAllProduct);

        Map<String, String> queryParams = {};
        if (event.fromDate != null) queryParams['fromdate'] = event.fromDate!;
        if (event.toDate != null) queryParams['todate'] = event.toDate!;
        if (event.search != null && event.search!.isNotEmpty) queryParams['search'] = event.search!;

        final finalUri = queryParams.isNotEmpty ? uri.replace(queryParameters: queryParams) : uri;

        developer.log("📤 Product API Request: $finalUri");

        final response = await http.get(
          finalUri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        );

        developer.log("📥 Product Response: ${response.statusCode}");
        developer.log(response.body);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          emit(ProductSuccessState(data['data'] ?? []));
        } else {
          emit(ProductErrorState('Failed to load products'));
        }
      } catch (e) {
        developer.log("❌ ProductBloc Error: $e");
        emit(ProductErrorState('Oops! Something went wrong. Please try again later.'));
      }
    });


    /// Create Product
    on<CreateProductEvent>((event, emit) async {
      emit(ProductLoadingState());
      try {
        final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.createProduct);
        developer.log("📤 Create Product uri: $uri");

        final userToken = PrefUtils.getToken();
        developer.log("📤 Create Product userToken: $userToken");

        final body = json.encode({
          "qcItemId": event.name,
        });

        developer.log("📤 Create Product Request: $body");

        final response = await http.post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
          body: body,
        );

        developer.log("📥 Response: ${response.statusCode}");
        developer.log(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = json.decode(response.body);
          emit(ProductCreateSuccessState(data));
        } else {
          emit(ProductErrorState('Failed to create product'));
        }
      } catch (e) {
        developer.log("❌ ProductBloc Error: $e");
        emit(ProductErrorState(e.toString()));
      }
    });

  }
}
