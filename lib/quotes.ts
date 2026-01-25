export interface Quote {
  id: number;
  text: string;
  text_ko?: string;
  author: string;
  category: string;
}

export const quotes: Quote[] = [
  { id: 1, text: "The only way to do great work is to love what you do.", text_ko: "훌륭한 일을 하는 유일한 방법은 자신이 하는 일을 사랑하는 것이다.", author: "Steve Jobs", category: "Work" },
  { id: 2, text: "In the middle of difficulty lies opportunity.", text_ko: "어려움의 한가운데 기회가 있다.", author: "Albert Einstein", category: "Perseverance" },
  { id: 3, text: "Life is what happens when you're busy making other plans.", text_ko: "인생은 당신이 다른 계획을 세우느라 바쁠 때 일어나는 것이다.", author: "John Lennon", category: "Life" },
  { id: 4, text: "The future belongs to those who believe in the beauty of their dreams.", text_ko: "미래는 자신의 꿈의 아름다움을 믿는 사람들의 것이다.", author: "Eleanor Roosevelt", category: "Dreams" },
  { id: 5, text: "It is during our darkest moments that we must focus to see the light.", text_ko: "가장 어두운 순간에 빛을 보기 위해 집중해야 한다.", author: "Aristotle", category: "Hope" },
  { id: 6, text: "The only impossible journey is the one you never begin.", text_ko: "불가능한 여정은 시작하지 않은 여정뿐이다.", author: "Tony Robbins", category: "Motivation" },
  { id: 7, text: "Success is not final, failure is not fatal: it is the courage to continue that counts.", text_ko: "성공이 끝이 아니고, 실패가 치명적인 것이 아니다. 중요한 것은 계속할 용기이다.", author: "Winston Churchill", category: "Success" },
  { id: 8, text: "Believe you can and you're halfway there.", text_ko: "할 수 있다고 믿으면 이미 반은 온 것이다.", author: "Theodore Roosevelt", category: "Belief" },
  { id: 9, text: "The best time to plant a tree was 20 years ago. The second best time is now.", text_ko: "나무를 심기 가장 좋은 때는 20년 전이었다. 두 번째로 좋은 때는 바로 지금이다.", author: "Chinese Proverb", category: "Action" },
  { id: 10, text: "Your time is limited, don't waste it living someone else's life.", text_ko: "당신의 시간은 한정되어 있다. 남의 인생을 사느라 낭비하지 마라.", author: "Steve Jobs", category: "Life" },
  { id: 11, text: "The mind is everything. What you think you become.", text_ko: "마음이 전부다. 생각하는 대로 된다.", author: "Buddha", category: "Mindset" },
  { id: 12, text: "Strive not to be a success, but rather to be of value.", text_ko: "성공하려 하지 말고, 가치 있는 사람이 되려고 노력하라.", author: "Albert Einstein", category: "Purpose" },
  { id: 13, text: "The only person you are destined to become is the person you decide to be.", text_ko: "당신이 될 운명인 사람은 당신이 되기로 결정한 사람뿐이다.", author: "Ralph Waldo Emerson", category: "Self" },
  { id: 14, text: "Go confidently in the direction of your dreams. Live the life you have imagined.", text_ko: "자신의 꿈을 향해 자신 있게 나아가라. 상상했던 삶을 살아라.", author: "Henry David Thoreau", category: "Dreams" },
  { id: 15, text: "When you arise in the morning think of what a privilege it is to be alive.", text_ko: "아침에 일어날 때 살아있다는 것이 얼마나 큰 특권인지 생각하라.", author: "Marcus Aurelius", category: "Gratitude" },
  { id: 16, text: "The secret of getting ahead is getting started.", text_ko: "앞서 나가는 비결은 시작하는 것이다.", author: "Mark Twain", category: "Action" },
  { id: 17, text: "It always seems impossible until it's done.", text_ko: "이루어지기 전까지는 항상 불가능해 보인다.", author: "Nelson Mandela", category: "Perseverance" },
  { id: 18, text: "Happiness is not something ready made. It comes from your own actions.", text_ko: "행복은 완성된 것이 아니다. 당신의 행동에서 온다.", author: "Dalai Lama", category: "Happiness" },
  { id: 19, text: "The greatest glory in living lies not in never falling, but in rising every time we fall.", text_ko: "삶의 가장 큰 영광은 넘어지지 않는 것이 아니라, 넘어질 때마다 일어서는 것이다.", author: "Nelson Mandela", category: "Resilience" },
  { id: 20, text: "Life is really simple, but we insist on making it complicated.", text_ko: "인생은 정말 단순한데, 우리가 복잡하게 만들고 있다.", author: "Confucius", category: "Life" },
  { id: 21, text: "Do what you can, with what you have, where you are.", text_ko: "지금 있는 곳에서, 가진 것으로, 할 수 있는 것을 하라.", author: "Theodore Roosevelt", category: "Action" },
  { id: 22, text: "Everything you've ever wanted is on the other side of fear.", text_ko: "당신이 원하는 모든 것은 두려움 너머에 있다.", author: "George Addair", category: "Courage" },
  { id: 23, text: "The way to get started is to quit talking and begin doing.", text_ko: "시작하는 방법은 말을 멈추고 행동을 시작하는 것이다.", author: "Walt Disney", category: "Action" },
  { id: 24, text: "If you want to lift yourself up, lift up someone else.", text_ko: "자신을 끌어올리고 싶다면, 다른 사람을 끌어올려라.", author: "Booker T. Washington", category: "Kindness" },
  { id: 25, text: "We are what we repeatedly do. Excellence, then, is not an act, but a habit.", text_ko: "우리는 반복적으로 하는 것이다. 탁월함은 행동이 아니라 습관이다.", author: "Aristotle", category: "Excellence" },
  { id: 26, text: "The purpose of our lives is to be happy.", text_ko: "우리 삶의 목적은 행복해지는 것이다.", author: "Dalai Lama", category: "Happiness" },
  { id: 27, text: "You miss 100% of the shots you don't take.", text_ko: "시도하지 않은 슛은 100% 실패한다.", author: "Wayne Gretzky", category: "Action" },
  { id: 28, text: "Whether you think you can or you think you can't, you're right.", text_ko: "할 수 있다고 생각하든, 할 수 없다고 생각하든, 당신이 옳다.", author: "Henry Ford", category: "Mindset" },
  { id: 29, text: "The best revenge is massive success.", text_ko: "최고의 복수는 엄청난 성공이다.", author: "Frank Sinatra", category: "Success" },
  { id: 30, text: "I have not failed. I've just found 10,000 ways that won't work.", text_ko: "나는 실패한 것이 아니다. 작동하지 않는 10,000가지 방법을 찾았을 뿐이다.", author: "Thomas Edison", category: "Perseverance" },
  { id: 31, text: "What lies behind us and what lies before us are tiny matters compared to what lies within us.", text_ko: "우리 뒤에 있는 것과 앞에 있는 것은 우리 안에 있는 것에 비하면 작은 문제다.", author: "Ralph Waldo Emerson", category: "Self" },
  { id: 32, text: "A person who never made a mistake never tried anything new.", text_ko: "실수를 한 번도 하지 않은 사람은 새로운 것을 시도하지 않은 사람이다.", author: "Albert Einstein", category: "Growth" },
  { id: 33, text: "The only limit to our realization of tomorrow is our doubts of today.", text_ko: "내일의 실현에 대한 유일한 한계는 오늘의 의심이다.", author: "Franklin D. Roosevelt", category: "Belief" },
  { id: 34, text: "It does not matter how slowly you go as long as you do not stop.", text_ko: "멈추지 않는 한 얼마나 천천히 가는지는 중요하지 않다.", author: "Confucius", category: "Perseverance" },
  { id: 35, text: "Everything has beauty, but not everyone sees it.", text_ko: "모든 것에는 아름다움이 있지만, 모든 사람이 보는 것은 아니다.", author: "Confucius", category: "Perspective" },
  { id: 36, text: "The journey of a thousand miles begins with one step.", text_ko: "천 리 길도 한 걸음부터 시작된다.", author: "Lao Tzu", category: "Beginning" },
  { id: 37, text: "That which does not kill us makes us stronger.", text_ko: "우리를 죽이지 못하는 것은 우리를 더 강하게 만든다.", author: "Friedrich Nietzsche", category: "Resilience" },
  { id: 38, text: "Love the life you live. Live the life you love.", text_ko: "살아가는 인생을 사랑하라. 사랑하는 인생을 살아라.", author: "Bob Marley", category: "Life" },
  { id: 39, text: "In order to be irreplaceable one must always be different.", text_ko: "대체 불가능해지려면 항상 달라야 한다.", author: "Coco Chanel", category: "Uniqueness" },
  { id: 40, text: "Nothing is impossible, the word itself says 'I'm possible'!", text_ko: "불가능한 것은 없다. 그 단어 자체가 '나는 가능하다'라고 말한다!", author: "Audrey Hepburn", category: "Possibility" },
  { id: 41, text: "The only true wisdom is in knowing you know nothing.", text_ko: "유일한 진정한 지혜는 아무것도 모른다는 것을 아는 것이다.", author: "Socrates", category: "Wisdom" },
  { id: 42, text: "Life is either a daring adventure or nothing at all.", text_ko: "인생은 대담한 모험이거나 아무것도 아니다.", author: "Helen Keller", category: "Adventure" },
  { id: 43, text: "Turn your wounds into wisdom.", text_ko: "상처를 지혜로 바꿔라.", author: "Oprah Winfrey", category: "Growth" },
  { id: 44, text: "The unexamined life is not worth living.", text_ko: "검토하지 않은 삶은 살 가치가 없다.", author: "Socrates", category: "Reflection" },
  { id: 45, text: "Be yourself; everyone else is already taken.", text_ko: "자신이 되어라. 다른 모든 사람은 이미 있다.", author: "Oscar Wilde", category: "Authenticity" },
  { id: 46, text: "Two things are infinite: the universe and human stupidity; and I'm not sure about the universe.", text_ko: "두 가지가 무한하다: 우주와 인간의 어리석음. 그리고 우주에 대해서는 확실하지 않다.", author: "Albert Einstein", category: "Humor" },
  { id: 47, text: "Be the change that you wish to see in the world.", text_ko: "세상에서 보고 싶은 변화가 되어라.", author: "Mahatma Gandhi", category: "Change" },
  { id: 48, text: "No one can make you feel inferior without your consent.", text_ko: "당신의 동의 없이는 아무도 당신을 열등하게 느끼게 할 수 없다.", author: "Eleanor Roosevelt", category: "Self-worth" },
  { id: 49, text: "Live as if you were to die tomorrow. Learn as if you were to live forever.", text_ko: "내일 죽을 것처럼 살아라. 영원히 살 것처럼 배워라.", author: "Mahatma Gandhi", category: "Learning" },
  { id: 50, text: "Darkness cannot drive out darkness: only light can do that.", text_ko: "어둠은 어둠을 몰아낼 수 없다. 오직 빛만이 할 수 있다.", author: "Martin Luther King Jr.", category: "Hope" },
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
