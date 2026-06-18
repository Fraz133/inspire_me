import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import '../models/quote_model.dart';

class ShareService extends GetxService {
  Future<void> shareQuote(QuoteModel quote) async {
    final encodedText = Uri.encodeComponent(quote.text);
    final encodedAuthor = Uri.encodeComponent(quote.author);
    final shareUrl = 'https://inspireme-82820.web.app/?text=$encodedText&author=$encodedAuthor';
    
    final text = '"${quote.text}"\n\n— ${quote.author}\n\n✨ View beautifully in your browser: $shareUrl\n\n📱 Shared from InspireMe App';
    await Share.share(text);
  }
}


