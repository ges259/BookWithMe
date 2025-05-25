//
//  HistoyChatView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/14/25.
//

import SwiftUI
import BottomSheet

// 한줄평 입력하는 메인 뷰
struct HistoryTextFieldView: View {
    @Binding var bottomSheetPosition: BottomSheetPosition
    // 입력 중인 텍스트(나중에 바인딩 해야함)
    @Binding var text: String
    
    // 텍스트필드 포커스 상태
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            // 상단 타이틀
            self.headerView
            
            VStack(spacing: 0) {
                // 텍스트 입력창
                self.textFieldView
                
                HStack {
                    // 태그 관련 뷰 (아직 내용 없음)
                    self.tagsView
                    Spacer()
                    // 다음 버튼
                    self.nextButton
                }
                .background(Color.contentsBackground1)
                .defaultCornerRadius(corners: .bottom)
            }
        }
        // 뷰 들어올 때 키보드 올림
        .onAppear {
            isTextFieldFocused = true
        }
        // 뷰 나갈 때 키보드 내림(포커스 해제)
        .onDisappear {
            isTextFieldFocused = false
        }
        .padding()
        .padding(.bottom, 60)
        
    }
}

// MARK: - UI
private extension HistoryTextFieldView {
    // 상단 제목 뷰
    var headerView: some View {
        return HeaderTitleView(
            title: "한줄평을 적어주세요",
            appFont: .historyTermHeader,
            alignment: .center
        )
    }
    
    // 텍스트 입력창
    var textFieldView: some View {
        return TextField("메시지를 입력하세요", text: $text, axis: .vertical)
            .textFieldStyle(.plain) // 기본 스타일 (배경 제거)
            .lineLimit(3...8) // 최소 3줄 ~ 최대 8줄까지 자동 확장
            .padding() // 내부 여백
            .focused($isTextFieldFocused) // 포커스 바인딩
            .background(Color.contentsBackground1) // 배경색
            .defaultCornerRadius(corners: .top) // 위쪽만 둥글게
    }
    
    // 태그 관련 뷰 (아직 내용 없음)
    var tagsView: some View {
        return Text("")
            .padding()
            .frame(height: 50) // 기본 높이 맞춤
    }
    
    // 다음 버튼
    var nextButton: some View {
        return Button {
            bottomSheetPosition = .hidden
        } label: {
            Image(systemName: "arrow.right.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .tint(Color.baseButton)
        }
        .padding([.trailing, .bottom], 10) // 위치 조정
    }
}
