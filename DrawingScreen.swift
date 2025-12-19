import SwiftUI
import PencilKit

struct DrawingScreen: View {
    @State private var canvasView = PKCanvasView()
    @State private var selectedColor: Color = .primary
    @State private var lineWidth: CGFloat = 5
    @State private var usingEraser = false

    private var currentTool: PKTool {
        if usingEraser {
            return PKEraserTool(.vector)
        } else {
            return PKInkingTool(.pen, color: UIColor(selectedColor), width: lineWidth)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            toolbar
                .padding(8)
                .background(.thinMaterial)

            Divider()

            PencilCanvasView(canvasView: $canvasView, tool: currentTool)
                .ignoresSafeArea(edges: .bottom)
        }
        .background(Color(uiColor: .systemBackground))
        .navigationTitle("Sketch")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var toolbar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                Button {
                    usingEraser = false
                } label: {
                    Label("Pen", systemImage: usingEraser ? "pencil" : "pencil.circle.fill")
                }
                .buttonStyle(.bordered)

                Button {
                    usingEraser = true
                } label: {
                    Label("Eraser", systemImage: usingEraser ? "eraser.fill" : "eraser")
                }
                .buttonStyle(.bordered)

                ColorPicker("Color", selection: $selectedColor)
                    .labelsHidden()

                HStack {
                    Image(systemName: "minus")
                    Slider(value: $lineWidth, in: 1...20)
                    Image(systemName: "plus")
                }
                .frame(maxWidth: 200)

                Button {
                    canvasView.undoManager?.undo()
                } label: {
                    Label("Undo", systemImage: "arrow.uturn.backward")
                }
                .buttonStyle(.bordered)

                Button {
                    canvasView.undoManager?.redo()
                } label: {
                    Label("Redo", systemImage: "arrow.uturn.forward")
                }
                .buttonStyle(.bordered)

                Button(role: .destructive) {
                    canvasView.drawing = PKDrawing()
                } label: {
                    Label("Clear", systemImage: "trash")
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
        }
    }
}

struct PencilCanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    var tool: PKTool

    func makeUIView(context: Context) -> PKCanvasView {

        canvasView.drawingPolicy = .anyInput
        canvasView.tool = tool
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.alwaysBounceVertical = false
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = tool
    }
}

#Preview("System") {
    NavigationStack {
        DrawingScreen()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        DrawingScreen()
    }
    .preferredColorScheme(.dark)
}
