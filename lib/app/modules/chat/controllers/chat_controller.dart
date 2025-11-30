import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart'; // Using MockAstrologer
import '../../../data/services/ai_service.dart';
import '../../../data/services/ad_service.dart';
import '../../../data/services/storage_service.dart';
import '../widgets/ad_modal.dart';
import '../../../core/constants/app_colors.dart';

class ChatController extends GetxController {
  final astrologer = Rxn<MockAstrologer>();
  final isLoading = true.obs;
  final messages = <Map<String, dynamic>>[].obs; // Mock Message Model
  final messageInput = ''.obs;
  final isTyping = false.obs;
  final ScrollController scrollController = ScrollController();


  final TextEditingController textController = TextEditingController();

  final AIService _aiService = AIService();
  // Get the persistent instance
  final AdService _adService = Get.find<AdService>();
  final StorageService _storageService = Get.find<StorageService>();
  
  // Use the service's observable
  RxInt get freeMessageCount => _adService.freeMessageCount;

  void onInputChanged(String val) {
    messageInput.value = val;
  }

  @override
  void onInit() {
    super.onInit();
    final id = Get.parameters['astrologerId'];
    if (id != null) {
      loadAstrologer(id);
    } else {
      isLoading.value = false;
    }
  }

  Future<void> loadAstrologer(String id) async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock Data Fetch
    astrologer.value = MockAstrologer(
      id: id,
      name: 'Nikki Diwan',
      specialty: 'Vedic, Vastu',
      rating: 4.8,
      reviewCount: 800,
      imageUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
    );

    // Load Persisted Messages
    final savedMessages = _storageService.getMessages(id);
    if (savedMessages.isNotEmpty) {
      messages.assignAll(savedMessages);
    } else {
      // Load Mock Messages if no history
      messages.addAll([
        {
          'message': 'Hello! How can I help you today?',
          'isUser': false,
          'time': '10:00 AM',
        },
      ]);
    }
    
    isLoading.value = false;
    scrollToBottom();
  }

  void sendMessage() {
    if (messageInput.value.trim().isEmpty) return;

    // Check Free Limit
    if (freeMessageCount.value <= 0) {
      _showAdModal();
      return;
    }
    
    final text = messageInput.value.trim();
    messages.add({
      'message': text,
      'isUser': true,
      'time': _formatTime(DateTime.now()),
    });
    
    _saveMessages();
    
    // Decrement Count via Service
    _adService.decrementCredit();

    messageInput.value = '';
    textController.clear();
    scrollToBottom();

    // Simulate AI Response
    _simulateAIResponse();
  }

  void _saveMessages() {
    if (astrologer.value != null) {
      _storageService.saveMessages(astrologer.value!.id, messages);
    }
  }

  void _showAdModal() {
    Get.dialog(
      AdModal(
        onWatchAd: _watchAd,
        onRemoveAds: _removeAds,
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _watchAd() async {
    // Show Loading
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Colors.white)),
      barrierDismissible: false,
    );

    final success = await _adService.showRewardedAd();
    
    Get.back(); // Close Loading

    if (success) {
      _adService.resetCredits(); // Reset limit via Service
      Get.snackbar(
        'Success',
        'You earned 3 more free messages!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _removeAds() {
    // TODO: Implement In-App Purchase
    Get.snackbar(
      'Premium',
      'Premium features coming soon!',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _simulateAIResponse() async {
    isTyping.value = true;
    scrollToBottom();
    
    final response = await _aiService.generateResponse(
      messages.last['message'], 
      astrologer.value?.name ?? 'Astrologer'
    );
    
    isTyping.value = false;
    messages.add({
      'message': response,
      'isUser': false,
      'time': _formatTime(DateTime.now()),
    });
    _saveMessages();
    scrollToBottom();
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime date) {
    return "${date.hour}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}";
  }

  void onMenuAction(String action) {
    switch (action) {
      case 'Clear Chat':
        _clearChat();
        break;
      case 'Report':
        _reportChat();
        break;
      case 'Block':
        _blockAstrologer();
        break;
    }
  }

  void _clearChat() {
    Get.defaultDialog(
      title: 'Clear Chat',
      middleText: 'Are you sure you want to delete all messages?',
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      onConfirm: () {
        messages.clear();
        if (astrologer.value != null) {
          _storageService.clearMessages(astrologer.value!.id);
        }
        Get.back(); // Close dialog
      },
    );
  }

  void _reportChat() {
    Get.defaultDialog(
      title: 'Report Astrologer',
      middleText: 'Do you want to report this astrologer for inappropriate behavior?',
      textConfirm: 'Report',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        Get.snackbar('Reported', 'Thank you for your feedback. We will investigate.');
      },
    );
  }

  void _blockAstrologer() {
    Get.defaultDialog(
      title: 'Block Astrologer',
      middleText: 'You will no longer receive messages from this astrologer.',
      textConfirm: 'Block',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // Close dialog
        Get.back(); // Exit chat
        Get.snackbar('Blocked', '${astrologer.value?.name} has been blocked.');
      },
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    textController.dispose();
    super.onClose();
  }
}
