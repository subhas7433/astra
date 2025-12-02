import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/numerology_model.dart';
import '../../../data/repositories/daily_content_repository.dart';

class NumerologyController extends GetxController {
  final DailyContentRepository _repository = Get.find<DailyContentRepository>();

  final dateController = TextEditingController();
  final selectedDate = Rxn<DateTime>();
  final lifePathNumber = RxnInt();
  final prediction = Rxn<NumerologyModel>();
  final isLoading = false.obs;

  @override
  void onClose() {
    dateController.dispose();
    super.onClose();
  }

  void onDateSelected(DateTime date) {
    selectedDate.value = date;
    dateController.text = '${date.day}/${date.month}/${date.year}';
    calculateLifePathNumber();
  }

  void calculateLifePathNumber() {
    if (selectedDate.value == null) return;

    final date = selectedDate.value!;
    int sum = _sumDigits(date.day) + _sumDigits(date.month) + _sumDigits(date.year);
    
    while (sum > 9 && sum != 11 && sum != 22 && sum != 33) {
      sum = _sumDigits(sum);
    }
    
    // For simplicity in this version, reduce master numbers to single digits
    // 11 -> 2, 22 -> 4, 33 -> 6
    if (sum > 9) {
      sum = _sumDigits(sum);
    }

    lifePathNumber.value = sum;
    fetchPrediction(sum);
  }

  int _sumDigits(int n) {
    int sum = 0;
    while (n > 0) {
      sum += n % 10;
      n ~/= 10;
    }
    return sum;
  }

  Future<void> fetchPrediction(int number) async {
    isLoading.value = true;
    final result = await _repository.getNumerologyPrediction(number);
    
    result.fold(
      onSuccess: (data) => prediction.value = data,
      onFailure: (error) => Get.snackbar('Error', error.message),
    );
    
    isLoading.value = false;
  }
}
