// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

struct PointerDisplayStrings {
    let title: String
    let caption: String

    static func localized(_ language: AppLanguage) -> PointerDisplayStrings {
        switch language {
        case .enUS: return .init(title: "Move pointer to next display", caption: "Puts the pointer in the center of the next display. The same modifiers with 1, 2 or 3 jump straight to that display, numbered left to right.")
        case .ptBR: return .init(title: "Mover ponteiro para o próximo display", caption: "Coloca o ponteiro no centro do próximo display. Os mesmos modificadores com 1, 2 ou 3 vão direto para esse display, numerados da esquerda para a direita.")
        case .tr: return .init(title: "İşaretçiyi sonraki ekrana taşı", caption: "İşaretçiyi sonraki ekranın ortasına götürür. Aynı değiştirici tuşlarla 1, 2 veya 3 doğrudan o ekrana geçer; ekranlar soldan sağa numaralanır.")
        case .ru: return .init(title: "Переместить указатель на следующий дисплей", caption: "Ставит указатель в центр следующего дисплея. Те же модификаторы с 1, 2 или 3 сразу переносят его на этот дисплей; нумерация слева направо.")
        case .es: return .init(title: "Mover puntero a la siguiente pantalla", caption: "Coloca el puntero en el centro de la siguiente pantalla. Los mismos modificadores con 1, 2 o 3 van directo a esa pantalla, numeradas de izquierda a derecha.")
        case .de: return .init(title: "Zeiger auf nächstes Display bewegen", caption: "Setzt den Zeiger in die Mitte des nächsten Displays. Dieselben Sondertasten mit 1, 2 oder 3 springen direkt zu diesem Display, von links nach rechts nummeriert.")
        case .fr: return .init(title: "Déplacer le pointeur vers l’écran suivant", caption: "Place le pointeur au centre de l’écran suivant. Les mêmes touches de modification avec 1, 2 ou 3 vont directement à cet écran, numérotés de gauche à droite.")
        case .it: return .init(title: "Sposta il puntatore al display successivo", caption: "Porta il puntatore al centro del display successivo. Gli stessi modificatori con 1, 2 o 3 vanno direttamente a quel display, numerati da sinistra a destra.")
        case .ja: return .init(title: "ポインタを次のディスプレイへ移動", caption: "ポインタを次のディスプレイの中央に移動します。同じ修飾キーと 1、2、3 で、そのディスプレイへ直接移動します（左から順に番号付け）。")
        case .ko: return .init(title: "포인터를 다음 디스플레이로 이동", caption: "포인터를 다음 디스플레이의 가운데로 옮깁니다. 같은 보조 키와 1, 2, 3을 누르면 해당 디스플레이로 바로 이동합니다(왼쪽부터 번호 지정).")
        case .zhHans: return .init(title: "将鼠标移到下一台显示器", caption: "将鼠标移到下一台显示器的中央。使用相同的修饰键加 1、2 或 3 可直接跳到对应显示器，从左到右编号。")
        case .zhTW: return .init(title: "將滑鼠移到下一台顯示器", caption: "將滑鼠移到下一台顯示器的中央。使用相同的修飾鍵加 1、2 或 3 可直接跳到對應顯示器，由左至右編號。")
        case .zhHK: return .init(title: "將滑鼠移到下一部顯示器", caption: "將滑鼠移到下一部顯示器的中央。使用相同的修飾鍵加 1、2 或 3 可直接跳到對應顯示器，由左至右編號。")
        }
    }
}
