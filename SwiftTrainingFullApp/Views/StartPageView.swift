import SwiftUI

struct StartPageView: View {
    @State var showGame = false
    var body: some View {
        NavigationStack{
            ZStack{
                Color.white
                    .ignoresSafeArea()
                VStack{
                    Text("Welcome to Set")
                        .font(.largeTitle)
                        .padding()
                        .foregroundColor(.black)
                    
                    
                    NavigationLink(destination: EmojiCardGameView(viewModel: EmojiCardGame())){
                        Text("Start Game")
                            .font(.title2)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                    }
                }
                .multilineTextAlignment(.center)
            }
            
        }
    }
}

#Preview {
    StartPageView()
}
