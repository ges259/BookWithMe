//
//  Book+Model.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI
struct Book: Identifiable {
    let id: String
    let title: String
    let author: String
    let publisher: String
    let description: String
    let imageURL: String?

    init(
        id: String,
        title: String,
        author: String,
        publisher: String,
        description: String,
        imageURL: String?
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.publisher = publisher
        self.description = description
        self.imageURL = imageURL
    }
}
extension Book {
    static func fromEntity(_ entity: BookEntity) -> Book {
        return Book(
            id: entity.imageURL ?? "",
            title: entity.bookId ?? "",
            author: entity.title ?? "",
            publisher: "김호연",
            description: "나무옆의자",
            imageURL:
    """
    서울역에서 노숙인 생활을 하던 독고라는 남자가 어느 날 70대 여성의 지갑을 주워준 인연으로 그녀가 운영하는 편의점에서 야간 알바를 시작하게 된다. 덩치가 곰 같은 이 사내는 알코올성 치매로 과거를 기억하지 못하는 데다 말도 어눌하고 행동도 굼떠 과연 손님을 제대로 상대할 수 있을까 의구심을 갖게 하는데 웬걸, 의외로 그는 일을 꽤 잘해낼 뿐 아니라 주변 사람들을 묘하게 사로잡으면서 편의점의 밤을 지키는 든든한 일꾼이 되어간다. 제각기 녹록지 않은 인생의 무게와 현실적 문제를 안고 있는 여러 이들은 각자의 시선으로 독고를 관찰하는데 그 과정에서 발생하는 오해와 대립, 충돌과 반전, 이해와 공감은 자주 독자의 폭소를 자아내고 어느 순간 울컥 눈시울이 붉어지게 한다. 그렇게 골목길의 작은 편의점은 불편하기 짝이 없는 곳이었다가 고단한 삶을 위로하고 웃음을 나누는 특별한 공간이 된다.
    """
        )
    }
}

extension Book {
    static var DUMMY_BOOK: Book = Book(
        id: "불편한편의점_표지",
        title: "9791161571331",
        author: "불편한 편의점",
        publisher: "김호연",
        description: "나무옆의자",
        imageURL:
"""
서울역에서 노숙인 생활을 하던 독고라는 남자가 어느 날 70대 여성의 지갑을 주워준 인연으로 그녀가 운영하는 편의점에서 야간 알바를 시작하게 된다. 덩치가 곰 같은 이 사내는 알코올성 치매로 과거를 기억하지 못하는 데다 말도 어눌하고 행동도 굼떠 과연 손님을 제대로 상대할 수 있을까 의구심을 갖게 하는데 웬걸, 의외로 그는 일을 꽤 잘해낼 뿐 아니라 주변 사람들을 묘하게 사로잡으면서 편의점의 밤을 지키는 든든한 일꾼이 되어간다. 제각기 녹록지 않은 인생의 무게와 현실적 문제를 안고 있는 여러 이들은 각자의 시선으로 독고를 관찰하는데 그 과정에서 발생하는 오해와 대립, 충돌과 반전, 이해와 공감은 자주 독자의 폭소를 자아내고 어느 순간 울컥 눈시울이 붉어지게 한다. 그렇게 골목길의 작은 편의점은 불편하기 짝이 없는 곳이었다가 고단한 삶을 위로하고 웃음을 나누는 특별한 공간이 된다.
"""
    )
}
