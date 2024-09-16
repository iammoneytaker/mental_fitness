import 'dart:math';

class LanguageGame {
  late String currentPuzzle;
  late List<String> shuffledPieces;
  late List<String> userAnswer;

  List<String> words = [
// 1글자 단어
    '꽃', '달', '돈', '말', '밤', '별', '술', '숲', '쥐', '집',
// 2글자 단어
    '가방', '가위', '겨울', '고래', '과자', '구름', '국수', '귤', '그릇', '기차',
    '나무', '냄비', '노을', '눈물', '달걀', '달력', '담요', '도끼', '돼지', '뜨개질',
    '마늘', '망치', '모자', '문어', '바늘', '바다', '바람', '밥', '벌레', '병아리',
    '보석', '부엌', '북', '불', '붓', '비누', '빗', '빵', '사탕', '사자',
    '산', '새', '색연필', '생선', '서랍', '소금', '수박', '숟가락', '양', '양말',
// 3글자 단어
    '가을', '감기', '거울', '게임', '고양이', '과일', '국자', '기린', '나비', '냉장고',
    '늑대', '다람쥐', '달팽이', '도서관', '두꺼비', '라면', '로봇', '머리띠', '메뚜기', '목도리',
    '물고기', '미나리', '바구니', '박쥐', '베개', '병원', '복숭아', '부채', '비행기', '사과',
    '산책', '생쥐', '수족관', '스키', '시계', '싸움', '악어', '앵무새', '양치기', '연필',
    '오리', '우산', '원숭이', '의자', '이발소', '자동차', '장갑', '저금통', '조개', '창문',
// 4글자 단어
    '가로수', '간장', '개구리', '거미줄', '고드름', '곰인형', '기차역', '나뭇잎', '녹차', '다이아몬드',
    '달무리', '도토리', '돼지고기', '디저트', '땅콩', '라디오', '마스크', '망원경', '물티슈', '바늘쌈지',
    '박물관', '볼펜', '분필', '비둘기', '사다리', '산타클로스', '성냥', '소나무', '수건', '스케이트',
    '싱크대', '안경', '양상추', '여우', '연못', '오징어', '우편함', '윷놀이', '의사', '인형',
    '자석', '잠자리', '장작', '전화기', '조명', '종이컵', '지우개', '책가방', '초콜릿', '카메라',
// 5글자 단어
    '가방끈', '강아지', '거미', '고속도로', '공룡', '과학자', '국기', '금메달', '나무젓가락', '냉면',
    '달걀말이', '도라지', '두부', '디지털카메라', '땅콩버터', '레몬', '마이크', '망원경', '모기', '물레방아',
    '바늘방석', '박쥐', '보석함', '부엌칼', '비옷', '사진기', '산삼', '생일케이크', '서커스', '소방관',
    '수박씨', '스키장', '시금치', '신발장', '양파', '여우비', '연필깎이', '오이', '요리사', '우편번호',
    '음료수', '의류', '인삼', '자동차키', '잠수함', '장미꽃', '전기장판', '조개껍데기', '주전자', '지렁이'
  ];

  List<String> sentences = [
    '나는 밥을 먹어요',
    '오늘은 날씨가 좋아요',
    '뽀로로는 펭귄이에요',
    '엄마 아빠 사랑해요',
    '우리 가족 화목해요',
    '강아지는 멍멍 짖어요',
    '고양이는 야옹야옹 울어요',
    '할아버지 할머니 보고 싶어요',
    '맛있는 음식을 먹으면 기분이 좋아져요',
    '아름다운 꽃이 활짝 피었어요',
    '즐겁게 운동을 해요',
    '좋아하는 노래를 들어요',
    '재미있는 책을 읽어요',
    '정직하게 살아가는 게 좋아요',
    '나는 사랑받는 사람이에요',
    '우리는 모두 소중한 사람들이에요',
    '오늘도 감사한 마음으로 살아가요',
    '웃음은 행복을 가져다줘요',
    '사랑하는 사람과 함께 있으면 행복해요',
    '자연의 아름다움을 느껴보세요',
    '건강이 가장 소중한 것이에요',
    '매일매일 성실하게 살아가요',
    '어려운 일도 포기하지 않아요',
    '나에게 주어진 하루를 감사히 살아요',
    '모두가 평화롭게 지냈으면 좋겠어요',
    // 더 많은 쉬운 문장 추가
  ];

  int score = 0;
  int level = 1;
  bool isCompleted = false;

  void startGame() {
    score = 0;
    level = 1;
    isCompleted = false;
    generateNewPuzzle();
  }

  void endGame() {
    isCompleted = true;
  }

  void generateNewPuzzle() {
    if (level <= 6) {
      // 레벨 1-6: 단어 퍼즐
      List<String> filteredWords =
          words.where((word) => word.length == level).toList();
      if (filteredWords.isNotEmpty) {
        currentPuzzle = filteredWords[Random().nextInt(filteredWords.length)];
      } else {
        // 해당 길이의 단어가 없으면 가장 가까운 길이의 단어 선택
        currentPuzzle = words.firstWhere((word) => word.length >= level,
            orElse: () => words.last);
      }
      shuffledPieces = currentPuzzle.split('')..shuffle();
    } else if (level <= 10) {
      // 레벨 7-10: 쉬운 문장 퍼즐
      List<String> easySentences = sentences.sublist(0, 10);
      currentPuzzle = easySentences[Random().nextInt(easySentences.length)];
      shuffledPieces = currentPuzzle.split(' ')..shuffle();
    } else {
      // 레벨 11 이상: 어려운 문장 퍼즐
      List<String> hardSentences = sentences.sublist(10);
      currentPuzzle = hardSentences[Random().nextInt(hardSentences.length)];
      shuffledPieces = currentPuzzle.split(' ')..shuffle();
    }
    userAnswer = List.filled(shuffledPieces.length, '');
  }

  bool checkAnswer() {
    String userAnswerString = userAnswer.join(level <= 6 ? '' : ' ').trim();
    if (userAnswerString == currentPuzzle) {
      score += 10;
      level++;
      generateNewPuzzle();
      return true;
    }
    return false;
  }

  void updateUserAnswer(int index, String piece) {
    userAnswer[index] = piece;
  }

  void removeLetterFromAnswer(int index) {
    userAnswer[index] = '';
  }
}
