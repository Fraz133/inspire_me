import '../models/quote_model.dart';

class QuoteProvider {
  static final List<QuoteModel> quotes = [
    QuoteModel(id: '1', text: 'The only way to do great work is to love what you do.', author: 'Steve Jobs'),
    QuoteModel(id: '2', text: 'Innovation distinguishes between a leader and a follower.', author: 'Steve Jobs'),
    QuoteModel(id: '3', text: 'Stay hungry, stay foolish.', author: 'Steve Jobs'),
    QuoteModel(id: '4', text: 'The future belongs to those who believe in the beauty of their dreams.', author: 'Eleanor Roosevelt'),
    QuoteModel(id: '5', text: 'It is during our darkest moments that we must focus to see the light.', author: 'Aristotle'),
    QuoteModel(id: '6', text: 'The best time to plant a tree was 20 years ago. The second best time is now.', author: 'Chinese Proverb'),
    QuoteModel(id: '7', text: 'Your limitation—it\'s only your imagination.', author: 'Unknown'),
    QuoteModel(id: '8', text: 'Push yourself, because no one else is going to do it for you.', author: 'Unknown'),
    QuoteModel(id: '9', text: 'Great things never come from comfort zones.', author: 'Unknown'),
    QuoteModel(id: '10', text: 'Dream it. Wish it. Do it.', author: 'Unknown'),
    QuoteModel(id: '11', text: 'Success doesn\'t just find you. You have to go out and get it.', author: 'Unknown'),
    QuoteModel(id: '12', text: 'The harder you work for something, the greater you\'ll feel when you achieve it.', author: 'Unknown'),
    QuoteModel(id: '13', text: 'Don\'t stop when you\'re tired. Stop when you\'re done.', author: 'Unknown'),
    QuoteModel(id: '14', text: 'Wake up with determination. Go to bed with satisfaction.', author: 'Unknown'),
    QuoteModel(id: '15', text: 'Do something today that your future self will thank you for.', author: 'Sean Patrick Flanery'),
    QuoteModel(id: '16', text: 'Little things make big days.', author: 'Unknown'),
    QuoteModel(id: '17', text: 'It\'s going to be hard, but hard does not mean impossible.', author: 'Unknown'),
    QuoteModel(id: '18', text: 'Don\'t wait for opportunity. Create it.', author: 'Unknown'),
    QuoteModel(id: '19', text: 'Sometimes we\'re tested not to show our weaknesses, but to discover our strengths.', author: 'Unknown'),
    QuoteModel(id: '20', text: 'The key to success is to focus on goals, not obstacles.', author: 'Unknown'),
    QuoteModel(id: '21', text: 'Dream bigger. Do bigger.', author: 'Unknown'),
    QuoteModel(id: '22', text: 'Believe you can and you\'re halfway there.', author: 'Theodore Roosevelt'),
    QuoteModel(id: '23', text: 'In the middle of every difficulty lies opportunity.', author: 'Albert Einstein'),
    QuoteModel(id: '24', text: 'Life is 10% what happens to us and 90% how we react to it.', author: 'Charles R. Swindoll'),
    QuoteModel(id: '25', text: 'The mind is everything. What you think you become.', author: 'Buddha'),
    QuoteModel(id: '26', text: 'Strive not to be a success, but rather to be of value.', author: 'Albert Einstein'),
    QuoteModel(id: '27', text: 'Two roads diverged in a wood, and I took the one less traveled by, and that has made all the difference.', author: 'Robert Frost'),
    QuoteModel(id: '28', text: 'I attribute my success to this: I never gave or took any excuse.', author: 'Florence Nightingale'),
    QuoteModel(id: '29', text: 'You miss 100% of the shots you don\'t take.', author: 'Wayne Gretzky'),
    QuoteModel(id: '30', text: 'The most difficult thing is the decision to act, the rest is merely tenacity.', author: 'Amelia Earhart'),
    QuoteModel(id: '31', text: 'Every strike brings me closer to the next home run.', author: 'Babe Ruth'),
    QuoteModel(id: '32', text: 'Whether you think you can or you think you can\'t, you\'re right.', author: 'Henry Ford'),
    QuoteModel(id: '33', text: 'The only impossible journey is the one you never begin.', author: 'Tony Robbins'),
    QuoteModel(id: '34', text: 'Act as if what you do makes a difference. It does.', author: 'William James'),
    QuoteModel(id: '35', text: 'What you get by achieving your goals is not as important as what you become by achieving your goals.', author: 'Zig Ziglar'),
  ];

  static QuoteModel getRandomQuote({String? excludeId}) {
    final available = excludeId != null
        ? quotes.where((q) => q.id != excludeId).toList()
        : quotes;
    available.shuffle();
    return available.first;
  }
}
