export interface Quote {
  id: number;
  text: string;
  author: string;
  category: string;
}

export const quotes: Quote[] = [
  { id: 1, text: "The only way to do great work is to love what you do.", author: "Steve Jobs", category: "Work" },
  { id: 2, text: "In the middle of difficulty lies opportunity.", author: "Albert Einstein", category: "Perseverance" },
  { id: 3, text: "Life is what happens when you're busy making other plans.", author: "John Lennon", category: "Life" },
  { id: 4, text: "The future belongs to those who believe in the beauty of their dreams.", author: "Eleanor Roosevelt", category: "Dreams" },
  { id: 5, text: "It is during our darkest moments that we must focus to see the light.", author: "Aristotle", category: "Hope" },
  { id: 6, text: "The only impossible journey is the one you never begin.", author: "Tony Robbins", category: "Motivation" },
  { id: 7, text: "Success is not final, failure is not fatal: it is the courage to continue that counts.", author: "Winston Churchill", category: "Success" },
  { id: 8, text: "Believe you can and you're halfway there.", author: "Theodore Roosevelt", category: "Belief" },
  { id: 9, text: "The best time to plant a tree was 20 years ago. The second best time is now.", author: "Chinese Proverb", category: "Action" },
  { id: 10, text: "Your time is limited, don't waste it living someone else's life.", author: "Steve Jobs", category: "Life" },
  { id: 11, text: "The mind is everything. What you think you become.", author: "Buddha", category: "Mindset" },
  { id: 12, text: "Strive not to be a success, but rather to be of value.", author: "Albert Einstein", category: "Purpose" },
  { id: 13, text: "The only person you are destined to become is the person you decide to be.", author: "Ralph Waldo Emerson", category: "Self" },
  { id: 14, text: "Go confidently in the direction of your dreams. Live the life you have imagined.", author: "Henry David Thoreau", category: "Dreams" },
  { id: 15, text: "When you arise in the morning think of what a privilege it is to be alive.", author: "Marcus Aurelius", category: "Gratitude" },
  { id: 16, text: "The secret of getting ahead is getting started.", author: "Mark Twain", category: "Action" },
  { id: 17, text: "It always seems impossible until it's done.", author: "Nelson Mandela", category: "Perseverance" },
  { id: 18, text: "Happiness is not something ready made. It comes from your own actions.", author: "Dalai Lama", category: "Happiness" },
  { id: 19, text: "The greatest glory in living lies not in never falling, but in rising every time we fall.", author: "Nelson Mandela", category: "Resilience" },
  { id: 20, text: "Life is really simple, but we insist on making it complicated.", author: "Confucius", category: "Life" },
  { id: 21, text: "Do what you can, with what you have, where you are.", author: "Theodore Roosevelt", category: "Action" },
  { id: 22, text: "Everything you've ever wanted is on the other side of fear.", author: "George Addair", category: "Courage" },
  { id: 23, text: "The way to get started is to quit talking and begin doing.", author: "Walt Disney", category: "Action" },
  { id: 24, text: "If you want to lift yourself up, lift up someone else.", author: "Booker T. Washington", category: "Kindness" },
  { id: 25, text: "We are what we repeatedly do. Excellence, then, is not an act, but a habit.", author: "Aristotle", category: "Excellence" },
  { id: 26, text: "The purpose of our lives is to be happy.", author: "Dalai Lama", category: "Happiness" },
  { id: 27, text: "You miss 100% of the shots you don't take.", author: "Wayne Gretzky", category: "Action" },
  { id: 28, text: "Whether you think you can or you think you can't, you're right.", author: "Henry Ford", category: "Mindset" },
  { id: 29, text: "The best revenge is massive success.", author: "Frank Sinatra", category: "Success" },
  { id: 30, text: "I have not failed. I've just found 10,000 ways that won't work.", author: "Thomas Edison", category: "Perseverance" },
  { id: 31, text: "What lies behind us and what lies before us are tiny matters compared to what lies within us.", author: "Ralph Waldo Emerson", category: "Self" },
  { id: 32, text: "A person who never made a mistake never tried anything new.", author: "Albert Einstein", category: "Growth" },
  { id: 33, text: "The only limit to our realization of tomorrow is our doubts of today.", author: "Franklin D. Roosevelt", category: "Belief" },
  { id: 34, text: "It does not matter how slowly you go as long as you do not stop.", author: "Confucius", category: "Perseverance" },
  { id: 35, text: "Everything has beauty, but not everyone sees it.", author: "Confucius", category: "Perspective" },
  { id: 36, text: "The journey of a thousand miles begins with one step.", author: "Lao Tzu", category: "Beginning" },
  { id: 37, text: "That which does not kill us makes us stronger.", author: "Friedrich Nietzsche", category: "Resilience" },
  { id: 38, text: "Love the life you live. Live the life you love.", author: "Bob Marley", category: "Life" },
  { id: 39, text: "In order to be irreplaceable one must always be different.", author: "Coco Chanel", category: "Uniqueness" },
  { id: 40, text: "Nothing is impossible, the word itself says 'I'm possible'!", author: "Audrey Hepburn", category: "Possibility" },
  { id: 41, text: "The only true wisdom is in knowing you know nothing.", author: "Socrates", category: "Wisdom" },
  { id: 42, text: "Life is either a daring adventure or nothing at all.", author: "Helen Keller", category: "Adventure" },
  { id: 43, text: "Turn your wounds into wisdom.", author: "Oprah Winfrey", category: "Growth" },
  { id: 44, text: "The unexamined life is not worth living.", author: "Socrates", category: "Reflection" },
  { id: 45, text: "Be yourself; everyone else is already taken.", author: "Oscar Wilde", category: "Authenticity" },
  { id: 46, text: "Two things are infinite: the universe and human stupidity; and I'm not sure about the universe.", author: "Albert Einstein", category: "Humor" },
  { id: 47, text: "Be the change that you wish to see in the world.", author: "Mahatma Gandhi", category: "Change" },
  { id: 48, text: "No one can make you feel inferior without your consent.", author: "Eleanor Roosevelt", category: "Self-worth" },
  { id: 49, text: "Live as if you were to die tomorrow. Learn as if you were to live forever.", author: "Mahatma Gandhi", category: "Learning" },
  { id: 50, text: "Darkness cannot drive out darkness: only light can do that.", author: "Martin Luther King Jr.", category: "Hope" },
];

export function getRandomQuote(): Quote {
  return quotes[Math.floor(Math.random() * quotes.length)];
}

export function getDailyQuote(): Quote {
  // Use the current date as seed for consistent daily quote
  const today = new Date();
  const seed = today.getFullYear() * 10000 + (today.getMonth() + 1) * 100 + today.getDate();
  const index = seed % quotes.length;
  return quotes[index];
}
