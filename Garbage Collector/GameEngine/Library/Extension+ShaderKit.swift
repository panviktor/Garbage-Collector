//
//  Extension+ShaderKit.swift
//
//  Created by Viktor on 26.08.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import SpriteKit



extension SKAttributeValue {
    public convenience init(size: CGSize) {
        let size = vector_float2(Float(size.width), Float(size.height))
        self.init(vectorFloat2: size)
    }
}

extension SKShader {
    convenience init(fromFile filename: String, uniforms: [SKUniform]? = nil, attributes: [SKAttribute]? = nil) {
        guard let path = Bundle.main.path(forResource: filename, ofType: "fsh") else {
            fatalError("Unable to find shader \(filename).fsh in bundle")
        }
        
        guard let source = try? String(contentsOfFile: path) else {
            fatalError("Unable to load shader \(filename).fsh")
        }
        
        if let uniforms = uniforms {
            self.init(source: source as String, uniforms: uniforms)
        } else {
            self.init(source: source as String)
        }
        
        if let attributes = attributes {
            self.attributes = attributes
        }
    }
}

extension SKUniform {
    public convenience init(name: String, color: SKColor) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        let colors = vector_float4([Float(r), Float(g), Float(b), Float(a)])
        
        self.init(name: name, vectorFloat4: colors)
    }
    
    public convenience init(name: String, size: CGSize) {
        let size = vector_float2(Float(size.width), Float(size.height))
        self.init(name: name, vectorFloat2: size)
    }
    
    public convenience init(name: String, point: CGPoint) {
        let point = vector_float2(Float(point.x), Float(point.y))
        self.init(name: name, vectorFloat2: point)
    }
}

extension SKShader {
    class func createWaterShader() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_speed", float: 3),
            SKUniform(name: "u_strength", float: 2.5),
            SKUniform(name: "u_frequency", float: 10)
        ]
        return SKShader(fromFile: "SHKWater", uniforms: uniforms)
    }
    
    class func createCircleWaveRainbowBlended() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_speed", float: 1),
            SKUniform(name: "u_brightness", float: 0.5),
            SKUniform(name: "u_strength", float: 2),
            SKUniform(name: "u_density", float: 100),
            SKUniform(name: "u_center", point: CGPoint(x: 0.68, y: 0.33)),
            SKUniform(name: "u_red", float: -1)
        ]
        
        return SKShader(fromFile: "SHKCircleWaveRainbowBlended", uniforms: uniforms)
    }
    
    class func createLightGrid() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_density", float: 8),
            SKUniform(name: "u_speed", float: 3),
            SKUniform(name: "u_group_size", float: 2),
            SKUniform(name: "u_brightness", float: 3),
        ]
        
        return SKShader(fromFile: "SHKLightGrid", uniforms: uniforms)
    }
}
