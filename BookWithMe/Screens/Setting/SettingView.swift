//
//  SettingView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

struct SettingView: View {
    private var nickname = "홍길동"
    private var image = "default_profile_image"
    
    var body: some View {
        VStack(alignment: .leading){
            List {
                profileSettingsSection
                    .listRowBackground(Color.contentsBackground1)
                    .listRowSeparator(.hidden)
                
                accountSettingsSection
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.contentsBackground1)
            }
//            .background(Color.blue) // 여기는 하면 안 됨

            
        }
        .listStyle(.automatic)
        .scrollContentBackground(.hidden)
        .defaultShadow()
        .defaultCornerRadius()
    }
    
    
    // MARK: - 프로필 설정 Section
    private var profileSettingsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("프로필 설정")
                .font(.headline)
            profileImageChangeRow
            nicknameChangeRow
        }
        .padding()
//        .background(Color.red)
        .cornerRadius(12)
    }
    
    private var profileImageChangeRow: some View {
        HStack {
            Text("이미지 변경")
            Spacer()
            Button(action: {
                // 이미지 변경 액션
            }) {
                Image(systemName: "photo.fill")
            }
        }
    }
    
    private var nicknameChangeRow: some View {
        HStack {
            Text("닉네임 변경")
            Spacer()
            Button(action: {
                // 닉네임 변경 액션
            }) {
                Text(nickname)
            }
        }
    }
    
    // MARK: - 계정설정 Section
    private var accountSettingsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("계정 설정")
                .font(.headline)
            logoutButton
            accountDeleteButton
        }
        .padding()
//        .background(Color.red)
        .cornerRadius(12)
    }
    
    private var logoutButton: some View {
        Button(action: {
            // 로그아웃 액션
        }) {
            HStack {
                Text("로그아웃")
                Spacer()
            }
        }
    }
    
    private var accountDeleteButton: some View {
        Button(action: {
            // 회원탈퇴 액션
        }) {
            HStack {
                Text("회원탈퇴")
                Spacer()
            }
        }
    }
}

#Preview {
    SettingView()
}
