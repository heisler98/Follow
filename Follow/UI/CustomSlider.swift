//
//  CustomSlider.swift
//  Follow
//
//  Created by Hunter Eisler on 6/13/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import SwiftUI

struct CustomSlider<Component: View>: View {
    
    @Binding var value: Double
    var range: (Double, Double)
    var knobWidth: CGFloat?
    let viewBuilder: (CustomSliderComponents) -> Component
    
    @State var feedbackGenerator : UISelectionFeedbackGenerator! = UISelectionFeedbackGenerator()
    
    init(value: Binding<Double>, range: (Double, Double), knobWidth: CGFloat? = nil,
         _ viewBuilder: @escaping (CustomSliderComponents) -> Component
    ) {
        _value = value
        self.range = range
        self.viewBuilder = viewBuilder
        self.knobWidth = knobWidth
    }
    
    var body: some View {
        return GeometryReader { geometry in
            self.view(geometry: geometry) // function below
                .onAppear {
                    self.feedbackGenerator.prepare()
            }.onDisappear {
                self.feedbackGenerator = nil
            }
        }
    }
    
    private func view(geometry: GeometryProxy) -> some View {
        let frame = geometry.frame(in: .global)
        let drag = DragGesture(minimumDistance: 0).onChanged({ drag in
            self.onDragChange(drag, frame) }
        ).onEnded { drag in
            self.feedbackGenerator.selectionChanged()
        }
        let offsetX = self.getOffsetX(frame: frame)
        let knobSize = CGSize(width: knobWidth ?? frame.height, height: frame.height)
        let barLeftSize = CGSize(width: CGFloat(offsetX + knobSize.width * 0.5), height:  frame.height)
        let barRightSize = CGSize(width: frame.width - barLeftSize.width, height: frame.height)
        // we will add our logic here..
        
        let modifiers = CustomSliderComponents(
            barLeft: CustomSliderModifier(name: .barLeft, size: barLeftSize, offset: 0),
            barRight: CustomSliderModifier(name: .barRight, size: barRightSize, offset: barLeftSize.width),
            knob: CustomSliderModifier(name: .knob, size: knobSize, offset: offsetX)
        )
        
        return ZStack { viewBuilder(modifiers).gesture(drag) }
        
    }
    
    private func onDragChange(_ drag: DragGesture.Value,_ frame: CGRect) {
        let width = (knob: Double(knobWidth ?? frame.size.height), view: Double(frame.size.width))
        let xrange = (min: Double(0), max: Double(width.view - width.knob))
        var value = Double(drag.startLocation.x + drag.translation.width) // knob center x
        value -= 0.5*width.knob // offset from center to leading edge of knob
        value = value > xrange.max ? xrange.max : value // limit to leading edge
        value = value < xrange.min ? xrange.min : value // limit to trailing edge
        value = value.convert(fromRange: (xrange.min, xrange.max), toRange: range)
        self.value = value
    }
    
    private func getOffsetX(frame: CGRect) -> CGFloat {
        let width = (knob: knobWidth ?? frame.size.height, view: frame.size.width)
        let xrange: (Double, Double) = (0, Double(width.view - width.knob))
        let result = self.value.convert(fromRange: range, toRange: xrange)
        return CGFloat(result)
    }
}

struct CustomSlider_Preview: PreviewProvider {
    static var previews: some View {
        CustomSlider(value: .constant(10), range: (0, 100)) { modifiers in
            ZStack {
                LinearGradient(gradient: .init(colors: [Color.blue, Color.green ]), startPoint: .leading, endPoint: .trailing)
                ZStack {
                    Circle().fill(Color.white)
                    Circle().stroke(Color.black.opacity(0.2), lineWidth: 2)
                    Text(("10")).font(.system(size: 11))
                }
                .padding([.top, .bottom], 2)
                .modifier(modifiers.knob)
            }.cornerRadius(15)
        }.frame(height: 30)
        
    }
}
