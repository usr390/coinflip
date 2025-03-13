import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var coinSide: String = "heads"
    @State private var spinDegrees: Double = 0
    // keep a reference so the player doesn’t get deallocated instantly
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        ZStack {
            // full-screen tappable area
            Color.black.opacity(0.001)
                .ignoresSafeArea()
                .onTapGesture {
                    flipCoin()
                }

            // coin image with its own tap gesture
            Image(coinSide)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .rotation3DEffect(
                    Angle(degrees: spinDegrees),
                    axis: (x: 0, y: 1, z: 0)
                )
                .animation(.easeInOut(duration: 0.6), value: spinDegrees)
                .onTapGesture {
                    flipCoin()
                }
        }
    }

    func flipCoin() {
        playSound()
        spinDegrees += 360
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            coinSide = Bool.random() ? "heads" : "tails"
        }
    }
    
    func playSound() {
        // find your audio file in the bundle
        guard let path = Bundle.main.path(forResource: "coinflip", ofType: "wav") else { return }

        
        let url = URL(fileURLWithPath: path)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("could not play sound: \(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
