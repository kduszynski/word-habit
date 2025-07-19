# Dokument wymagań produktu (PRD) - Word Habit

## 1. Przegląd produktu

Word Habit to responsywna aplikacja webowa (RWD) zaprojektowana z myślą o podejściu "mobile-first" i gotowością do zbudowania aplikacji mobilnych z jednej bazy kodu. Jej celem jest pomoc użytkownikom w systematycznym uczeniu się słownictwa z języka angielskiego i polskiego. Aplikacja opiera się na filozofii "atomowych nawyków", koncentrując się na nauce jednego nowego słowa każdego dnia w celu budowania trwałej wiedzy.

Główne funkcjonalności obejmują tworzenie osobistego słownika poprzez manualne wprowadzanie słów lub z pomocą tłumaczeń generowanych przez AI, przeglądanie i usuwanie słów, a także otrzymywanie codziennych, konfigurowalnych powiadomień. Wersja MVP jest całkowicie darmowa i skierowana do szerokiej grupy odbiorców, niezależnie od wieku i poziomu zaawansowania językowego.

## 2. Problem użytkownika

Uczenie się nowych słów, ich tłumaczeń i kontekstów użycia w języku obcym wymaga systematyczności, co dla wielu osób stanowi wyzwanie. Problem polega na braku regularności i narzędzi wspierających ciągłość w procesie nauki. Zgodnie z filozofią małych kroków, codzienne przyswajanie nawet jednego słowa może przynieść znaczące rezultaty w długiej perspektywie. Word Habit ma na celu rozwiązanie tego problemu poprzez dostarczenie prostego w obsłudze narzędzia, które pomaga wbudować codzienny nawyk nauki słownictwa.

## 3. Wymagania funkcjonalne

### 3.1. System kont użytkowników
- Użytkownik musi mieć możliwość rejestracji konta za pomocą adresu e-mail i hasła.
- Użytkownik musi mieć możliwość logowania się na swoje konto za pomocą adresu e-mail i hasła.

### 3.2. Zarządzanie słownikiem (CRUD)
- C (Create): Użytkownik może dodawać nowe słowa (PL-EN lub EN-PL) na dwa sposoby:
    1. Manualnie: Wprowadzając wszystkie dane ręcznie (słowo, tłumaczenie, synonimy, przykłady użycia, typ gramatyczny).
    2. Z pomocą AI: Wpisując słowo i klikając przycisk "Generuj". Aplikacja w ciągu maksymalnie 10 sekund wypełnia resztę pól. W tym czasie interfejs jest zablokowany i widoczna jest animacja ładowania.
- R (Read): Użytkownik może przeglądać listę wszystkich dodanych przez siebie słów (widok podstawowy: słowo + główne tłumaczenie). Po kliknięciu w pozycję na liście, użytkownik przechodzi do widoku szczegółowego ze wszystkimi zapisanymi informacjami.
- D (Delete): Użytkownik może trwale usunąć słowo ze swojego słownika. Operacja ta wymaga dodatkowego potwierdzenia.

### 3.3. System nauki i powiadomień
- Użytkownik może w ustawieniach aplikacji skonfigurować dokładną godzinę (format HH:MM) otrzymywania codziennych powiadomień.
- Użytkownik może wyłączyć powiadomienia na wybrane dni tygodnia.
- Aplikacja codziennie wysyła powiadomienie z jednym słowem do nauki, wybranym przez algorytm.
- Użytkownik może oznaczyć słowo jako "znane", aby wykluczyć je z puli przyszłych powiadomień.

### 3.4. Algorytm wyboru słów do powiadomień
- Algorytm wybiera słowo, które nie zostało wysłane w powiadomieniu w ciągu ostatnich 60 dni i nie jest oznaczone jako "znane".
- Jeśli wszystkie słowa w słowniku były już ostatnio przypominane, algorytm wybiera to, które było wysłane najwcześniej spośród słów nie oznaczonych jako "znane"
- Jeśli w słowniku nie ma słów (jest pusty lub wszystkie są oznaczone jako "znane"), powiadomienie nie jest wysyłane.

## 4. Granice produktu

### 4.1. Funkcjonalności zawarte w MVP
- Rejestracja i logowanie użytkowników (e-mail + hasło).
- Tłumaczenie słów wyłącznie pomiędzy językiem polskim a angielskim lub angielskim a polskim.
- Ręczne tworzenie tłumaczeń.
- Generowanie tłumaczeń z pomocą AI.
- Przeglądanie i usuwanie słów.
- Konfigurowalny system codziennych powiadomień.
- Możliwość edycji zapisanych słów.

### 4.2. Funkcjonalności wykluczone z MVP
- Import słów z plików zewnętrznych (np. PDF, DOCX).
- Współdzielenie słowników i list słów między użytkownikami.
- Tłumaczenia w innych parach językowych niż PL-EN / EN-PL.
- Integracje z zewnętrznymi platformami edukacyjnymi.
- Tworzenie kopii zapasowych danych użytkowników.

## 5. Historyjki użytkowników

### 5.1. Uwierzytelnianie i Zarządzanie Kontem

*   ID: US-001
*   Tytuł: Rejestracja nowego użytkownika
*   Opis: Jako osoba zainteresowana aplikacją, chcę móc założyć nowe konto przy użyciu mojego adresu e-mail i hasła, aby uzyskać dostęp do tworzenia własnego słownika.
*   Kryteria akceptacji:
    1.  Gdy podaję prawidłowy, niezarejestrowany wcześniej adres e-mail i hasło (spełniające wymogi bezpieczeństwa), moje konto zostaje utworzone, a ja jestem automatycznie zalogowany i przekierowany do głównego widoku aplikacji.
    2.  Gdy próbuję zarejestrować się przy użyciu adresu e-mail, który już istnieje w systemie, widzę komunikat błędu: "Użytkownik o tym adresie e-mail już istnieje."
    3.  Gdy podaję adres e-mail w nieprawidłowym formacie, widzę komunikat błędu: "Proszę podać poprawny adres e-mail."
    4.  Gdy hasła w polach "Hasło" i "Powtórz hasło" nie są identyczne, widzę komunikat błędu: "Hasła nie są zgodne."

*   ID: US-002
*   Tytuł: Logowanie do aplikacji
*   Opis: Jako zarejestrowany użytkownik, chcę móc zalogować się do aplikacji przy użyciu mojego e-maila i hasła, aby uzyskać dostęp do mojego słownika.
*   Kryteria akceptacji:
    1.  Gdy podaję prawidłowy e-mail i hasło, zostaję pomyślnie zalogowany i widzę listę moich słów.
    2.  Gdy podaję błędny e-mail lub hasło, widzę komunikat błędu: "Nieprawidłowy adres e-mail lub hasło."
    3.  Po 5 nieudanych próbach logowania z jednego adresu IP, możliwość logowania jest tymczasowo blokowana na 15 minut.

### 5.2. Zarządzanie słownikiem

*   ID: US-003
*   Tytuł: Ręczne dodawanie nowego słowa do słownika
*   Opis: Jako użytkownik, chcę mieć możliwość ręcznego dodania nowego słowa wraz z jego tłumaczeniem, synonimami, przykładem użycia i typem gramatycznym, aby precyzyjnie kontrolować zawartość mojego słownika.
*   Kryteria akceptacji:
    1.  Gdy jestem na ekranie dodawania słowa, widzę formularz z polami: "Słowo", "Tłumaczenie", "Synonimy", "Przykłady użycia", "Typ gramatyczny".
    2.  Gdy wypełnię co najmniej pole "Słowo" i "Tłumaczenie", przycisk "Zapisz" staje się aktywny.
    3.  Gdy klikam "Zapisz", nowe słowo pojawia się na mojej liście słów.

*   ID: US-004
*   Tytuł: Dodawanie nowego słowa z pomocą AI
*   Opis: Jako użytkownik, chcę wpisać słowo i użyć funkcji "Tłumacz", aby AI automatycznie uzupełniło dla mnie tłumaczenie, synonimy, przykłady użycia i dane gramatyczne, co pozwoli mi szybko dodać kompleksowy wpis.
*   Kryteria akceptacji:
    1.  Gdy wpisuję słowo w pole "Słowo" i klikam przycisk "Tłumacz", cały ekran zostaje zablokowany, a na środku pojawia się animacja ładowania.
    2.  W ciągu 10 sekund pola formularza (Tłumaczenie, Synonimy, etc.) zostają wypełnione danymi od AI, a blokada ekranu znika.
    3.  Gdy dane zostaną wygenerowane, mogę je zaakceptować klikając "Zapisz", co dodaje słowo do mojego słownika.
    4. Użytkownik może również edytować tłumaczenie wygenerowane przez AI. Pola są dostępne do edycji. Po wyedytowaniu użytkownik klika przycisk "Zapisz", co dodaje słowo do mojego słownika.

*   ID: US-005
*   Tytuł: Obsługa błędu generowania przez AI
*   Opis: Jako użytkownik, w przypadku gdy generowanie tłumaczenia przez AI nie powiedzie się, chcę zobaczyć stosowny komunikat i mieć możliwość ponowienia próby.
*   Kryteria akceptacji:
    1.  Gdy proces generowania AI zakończy się błędem (np. z powodu problemów z siecią lub przekroczenia limitu czasu), animacja ładowania znika.
    2.  Na ekranie pojawia się komunikat: "Nie udało się wygenerować tłumaczenia. Spróbuj ponownie."
    3.  Przycisk "Generuj" ponownie staje się aktywny, umożliwiając ponowienie zapytania.

*   ID: US-006
*   Tytuł: Przeglądanie listy słów
*   Opis: Jako użytkownik, chcę widzieć listę wszystkich moich zapisanych słów, aby mieć szybki wgląd w zawartość mojego słownika.
*   Kryteria akceptacji:
    1.  Gdy loguję się do aplikacji, domyślnym widokiem jest lista słów. Na liście słów można wyszukiwać słowa, a także sortować je alfabetycznie od A-Z lub Z-A.
    2.  Każdy element listy zawiera oryginalne słowo i jego podstawowe tłumaczenie.
    3.  Gdy mój słownik jest pusty, widzę komunikat "Twój słownik jest pusty. Dodaj pierwsze słowo, aby rozpocząć naukę!".

*   ID: US-007
*   Tytuł: Przeglądanie szczegółów słowa
*   Opis: Jako użytkownik, chcę mieć możliwość kliknięcia na dowolne słowo z mojej listy, aby zobaczyć jego pełne szczegóły i lepiej je zrozumieć.
*   Kryteria akceptacji:
    1.  Gdy klikam na element na liście słów, jestem przenoszony na nowy ekran szczegółów tego słowa.
    2.  Ekran szczegółów wyświetla wszystkie zapisane informacje: słowo, tłumaczenie, synonimy, przykłady użycia i typ gramatyczny.

*   ID: US-008
*   Tytuł: Usuwanie słowa ze słownika
*   Opis: Jako użytkownik, chcę mieć możliwość usunięcia słowa, którego już się nauczyłem lub które dodałem przez pomyłkę.
*   Kryteria akceptacji:
    1.  Gdy w widoku szczegółów słowa klikam przycisk "Usuń", pojawia się modal z prośbą o potwierdzenie: "Czy na pewno chcesz usunąć to słowo?".
    2.  Gdy potwierdzam usunięcie, słowo jest trwale usuwane z mojego słownika, a ja jestem przenoszony z powrotem do widoku listy.
    3.  Gdy anuluję operację, modal znika, a ja pozostaję w widoku szczegółów słowa.

*   ID: US-009
*   Tytuł: Edytowanie tłumaczenia w słowniku
*   Opis: Jako użytkownik, chcę mieć możliwość wyedytowania tłumaczenia, którego znajduje się w moim słowniku.
*   Kryteria akceptacji:
    1.  Gdy w widoku szczegółów słowa klikam przycisk "Edytuj", pojawia się ekran umożliwiający edycję wszystkich pól, oprócz oryginalnego słowa.
    2.  Użytkownik może wyedytować wszystkie pola, oprócz oryginalnego słowa.
    3.  Po zakończonej edycji użytkownik klika przycisk "Zapisz", który zapisuje wyedytowane tłumaczenie. Użytkownik może również zrezygnować z edycji poprzez naciśniecie przycisku "Anuluj", wówczas wyedytowane dane nie są zapisywane.

### 5.3. Nauka i Powiadomienia

*   ID: US-010
*   Tytuł: Konfiguracja powiadomień
*   Opis: Jako użytkownik, chcę móc ustawić preferowaną godzinę codziennych powiadomień oraz wybrać dni tygodnia, w które chcę je otrzymywać, aby dopasować naukę do mojego harmonogramu.
*   Kryteria akceptacji:
    1.  W ustawieniach aplikacji znajduje się sekcja "Powiadomienia".
    2.  Mogę ustawić dokładną godzinę (HH:MM) dla powiadomień.
    3.  Mogę zaznaczyć lub odznaczyć poszczególne dni tygodnia (poniedziałek-niedziela), aby włączyć lub wyłączyć powiadomienia w te dni.
    4.  Zmiany zapisują się automatycznie po ich dokonaniu.

*   ID: US-011
*   Tytuł: Otrzymywanie codziennego powiadomienia
*   Opis: Jako użytkownik, chcę codziennie o ustalonej porze otrzymywać powiadomienie z jednym słowem z mojego słownika, aby systematycznie budować nawyk nauki.
*   Kryteria akceptacji:
    1.  Codziennie o godzinie ustawionej przez użytkownika system wysyła powiadomienie push.
    2.  Powiadomienie zawiera jedno słowo i jego tłumaczenie.
    3.  Kliknięcie w powiadomienie otwiera aplikację i przenosi bezpośrednio do ekranu szczegółów danego słowa.
    4.  Powiadomienie nie jest wysyłane, jeśli na dany dzień tygodnia powiadomienia są wyłączone.

*   ID: US-012
*   Tytuł: Oznaczanie słowa jako "znane"
*   Opis: Jako użytkownik, chcę mieć możliwość oznaczenia słowa jako "znane", aby aplikacja przestała mi je przypominać i skupiła się na słowach, których jeszcze nie umiem.
*   Kryteria akceptacji:
    1.  Na ekranie szczegółów słowa znajduje się przycisk/ikona "Oznacz jako znane".
    2.  Po kliknięciu przycisku, słowo zostaje oflagowane jako "znane" i nie będzie więcej pojawiać się w powiadomieniach.
    3.  Przycisk zmienia swój stan, np. na "Oznacz jako nieznane", umożliwiając cofnięcie akcji.

## 6. Metryki sukcesu

1.  Akceptacja tłumaczeń AI: 75% tłumaczeń wygenerowanych przez AI jest akceptowanych (zapisywanych) przez użytkowników.
    *   Sposób pomiaru: Stosunek liczby zapisanych słów po użyciu funkcji "Generuj" do całkowitej liczby zapytań do AI.

2.  Wykorzystanie funkcji AI: 75% wszystkich słów dodawanych do słowników jest tworzonych przy użyciu funkcji generowania przez AI.
    *   Sposób pomiaru: Stosunek liczby słów dodanych z pomocą AI do całkowitej liczby słów dodanych do wszystkich słowników.