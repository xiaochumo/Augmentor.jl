@testset "Crop" begin
    @test (Crop <: Augmentor.AffineOperation) == false
    @testset "constructor" begin
        @test_throws MethodError Crop()
        @test_throws MethodError Crop(())
        @test typeof(@inferred(Crop(1:10))) <: Crop{1} <: Crop <: Augmentor.ImageOperation
        @test typeof(@inferred(Crop(1:10,3:5))) <: Crop{2} <: Crop <: Augmentor.ImageOperation
        @test @inferred(Crop(1,4,10,5)) === @inferred(Crop((4:8,1:10)))
        @test @inferred(Crop(Base.OneTo(10), Base.OneTo(5))) === @inferred(Crop((1:10,1:5)))
        @test @inferred(Crop(Base.OneTo(10), 1:5)) === @inferred(Crop((1:10,1:5)))
        @test str_show(Crop(3:4)) == "Augmentor.Crop{1}((3:4,))"
        @test str_showconst(Crop(3:4)) == "Crop(3:4)"
        @test str_showcompact(Crop(3:4)) == "Crop region (3:4,)"
        @test str_show(Crop(1:2,2:3)) == "Augmentor.Crop{2}((1:2, 2:3))"
        @test str_showconst(Crop(1:2,2:3)) == "Crop(1:2, 2:3)"
        @test str_showcompact(Crop(1:2,2:3)) == "Crop region 1:2×2:3"
        @test str_show(Crop(1:2,2:3,3:4)) == "Augmentor.Crop{3}((1:2, 2:3, 3:4))"
        @test str_showconst(Crop(1:2,2:3,3:4)) == "Crop(1:2, 2:3, 3:4)"
        @test str_showcompact(Crop(1:2,2:3,3:4)) == "Crop region (1:2, 2:3, 3:4)"
    end
    @testset "eager" begin
        @test_throws MethodError Augmentor.applyeager(Crop(1:10), nothing)
        @test_throws MethodError Augmentor.applyeager(Crop(1:2,2:3), nothing)
        @test Augmentor.supports_eager(Crop) === false
        for img in (Augmentor.prepareaffine(rect), rect, OffsetArray(rect, -2, -1), view(rect, IdentityRange(1:2), IdentityRange(1:3)))
            @test @inferred(Augmentor.applyeager(Crop(1:2,2:3), img)) == rect[1:2, 2:3]
            @test typeof(Augmentor.applyeager(Crop(1:2,2:3), img)) <: Array
        end
    end
    @testset "affine" begin
        @test Augmentor.supports_affine(Crop) === false
    end
    @testset "affineview" begin
        @test Augmentor.supports_affineview(Crop) === true
        @test_throws MethodError Augmentor.applyaffineview(Crop(1:2,2:3), nothing)
        @test @inferred(Augmentor.applyaffineview(Crop(1:2,2:3), rect)) == view(Augmentor.prepareaffine(rect), IdentityRange(1:2), IdentityRange(2:3))
    end
    @testset "lazy" begin
        @test Augmentor.supports_lazy(Crop) === true
        @test @inferred(Augmentor.applylazy(Crop(1:2,2:3), rect)) === view(rect, IdentityRange(1:2), IdentityRange(2:3))
    end
    @testset "view" begin
        @test Augmentor.supports_view(Crop) === true
        @test @inferred(Augmentor.applyview(Crop(1:2,2:3), rect)) === view(rect, IdentityRange(1:2), IdentityRange(2:3))
    end
    @testset "stepview" begin
        @test Augmentor.supports_stepview(Crop) === true
        @test @inferred(Augmentor.applystepview(Crop(1:2,2:3), rect)) === view(rect, 1:1:2, 2:1:3)
    end
    @testset "permute" begin
        @test Augmentor.supports_permute(Crop) === false
    end
end

# --------------------------------------------------------------------

@testset "CropNative" begin
    @test (CropNative <: Augmentor.AffineOperation) == false
    @testset "constructor" begin
        @test_throws MethodError CropNative()
        @test_throws MethodError CropNative(())
        @test typeof(@inferred(CropNative(1:10))) <: CropNative{1} <: CropNative <: Augmentor.ImageOperation
        @test typeof(@inferred(CropNative(1:10,3:5))) <: CropNative{2} <: CropNative <: Augmentor.ImageOperation
        @test @inferred(CropNative(1,4,10,5)) === @inferred(CropNative((4:8,1:10)))
        @test @inferred(CropNative(Base.OneTo(10), Base.OneTo(5))) === @inferred(CropNative((1:10,1:5)))
        @test @inferred(CropNative(Base.OneTo(10), 1:5)) === @inferred(CropNative((1:10,1:5)))
        @test str_show(CropNative(3:4)) == "Augmentor.CropNative{1}((3:4,))"
        @test str_showconst(CropNative(3:4)) == "CropNative(3:4)"
        @test str_showcompact(CropNative(3:4)) == "Crop native region (3:4,)"
        @test str_show(CropNative(1:2,2:3)) == "Augmentor.CropNative{2}((1:2, 2:3))"
        @test str_showconst(CropNative(1:2,2:3)) == "CropNative(1:2, 2:3)"
        @test str_showcompact(CropNative(1:2,2:3)) == "Crop native region 1:2×2:3"
        @test str_show(CropNative(1:2,2:3,3:4)) == "Augmentor.CropNative{3}((1:2, 2:3, 3:4))"
        @test str_showconst(CropNative(1:2,2:3,3:4)) == "CropNative(1:2, 2:3, 3:4)"
        @test str_showcompact(CropNative(1:2,2:3,3:4)) == "Crop native region (1:2, 2:3, 3:4)"
    end
    @testset "eager" begin
        @test_throws MethodError Augmentor.applyeager(CropNative(1:10), nothing)
        @test_throws MethodError Augmentor.applyeager(CropNative(1:2,2:3), nothing)
        @test Augmentor.supports_eager(CropNative) === false
        for img in (Augmentor.prepareaffine(rect), rect, view(rect, IdentityRange(1:2), IdentityRange(1:3)))
            @test @inferred(Augmentor.applyeager(CropNative(1:2,2:3), img)) == rect[1:2, 2:3]
            @test typeof(Augmentor.applyeager(CropNative(1:2,2:3), img)) <: Array
        end
        img = OffsetArray(rect, -2, -1)
        @test @inferred(Augmentor.applyeager(CropNative(-1:0,1:2), img)) == rect[1:2, 2:3]
        @test typeof(Augmentor.applyeager(CropNative(-1:0,1:2), img)) <: Array
    end
    @testset "affine" begin
        @test Augmentor.supports_affine(CropNative) === false
    end
    @testset "affineview" begin
        @test Augmentor.supports_affineview(CropNative) === true
        @test_throws MethodError Augmentor.applyaffineview(CropNative(1:2,2:3), nothing)
        @test @inferred(Augmentor.applyaffineview(CropNative(1:2,2:3), rect)) == view(Augmentor.prepareaffine(rect), IdentityRange(1:2), IdentityRange(2:3))
    end
    @testset "lazy" begin
        @test Augmentor.supports_lazy(CropNative) === true
        @test @inferred(Augmentor.applylazy(CropNative(1:2,2:3), rect)) === view(rect, IdentityRange(1:2), IdentityRange(2:3))
    end
    @testset "view" begin
        @test Augmentor.supports_view(CropNative) === true
        @test @inferred(Augmentor.applyview(CropNative(1:2,2:3), rect)) === view(rect, IdentityRange(1:2), IdentityRange(2:3))
    end
    @testset "stepview" begin
        @test Augmentor.supports_stepview(CropNative) === true
        @test @inferred(Augmentor.applystepview(CropNative(1:2,2:3), rect)) === view(rect, 1:1:2, 2:1:3)
    end
    @testset "permute" begin
        @test Augmentor.supports_permute(CropNative) === false
    end
end

# --------------------------------------------------------------------

@testset "CropSize" begin
    @test (CropSize <: Augmentor.AffineOperation) == false
    @test typeof(@inferred(CropSize())) <: CropSize <: Augmentor.ImageOperation
    @testset "constructor" begin
        @test_throws MethodError CropSize(())
        @test_throws MethodError CropSize(1.,2.)
        @test_throws MethodError CropSize(:a)
        @test_throws MethodError CropSize([:a])
        @test_throws ArgumentError CropSize(-1)
        @test_throws ArgumentError CropSize(0,2)
        op = @inferred(CropSize(10))
        @test str_show(op) == "Augmentor.CropSize{1}((10,))"
        @test str_showconst(op) == "CropSize(10)"
        @test str_showcompact(op) == "Crop a 10-length window at the center"
        op = @inferred(CropSize(20,30))
        @test op === CropSize(width=30, height=20)
        @test op.size == (20,30)
        @test str_show(op) == "Augmentor.CropSize{2}((20, 30))"
        @test str_showconst(op) == "CropSize(20, 30)"
        @test str_showcompact(op) == "Crop a 20×30 window around the center"
        op = @inferred(CropSize(20,30,40))
        @test op === @inferred(CropSize((20,30,40)))
        @test op === @inferred(CropSize{3}((20,30,40)))
        @test op.size == (20,30,40)
        @test str_show(op) == "Augmentor.CropSize{3}((20, 30, 40))"
        @test str_showconst(op) == "CropSize(20, 30, 40)"
        @test str_showcompact(op) == "Crop a 20×30×40 window around the center"
    end
    @testset "eager" begin
        @test_throws MethodError Augmentor.applyeager(CropSize(10), nothing)
        @test_throws MethodError Augmentor.applyeager(CropSize(2,3), nothing)
        @test Augmentor.supports_eager(CropSize) === false
        for img in (rect, OffsetArray(rect, -2, -1), view(rect, IdentityRange(1:2), IdentityRange(1:3)))
            @test @inferred(Augmentor.applyeager(CropSize(2,3), img)) == rect
            @test typeof(Augmentor.applyeager(CropSize(2,3), img)) <: Array
        end
        @test @inferred(Augmentor.applyeager(CropSize(2,2), square2)) == square2[2:3,2:3]
        @test @inferred(Augmentor.applyeager(CropSize(4,4), square2)) == square2
    end
    @testset "affine" begin
        @test Augmentor.supports_affine(CropSize) === false
    end
    @testset "affineview" begin
        @test Augmentor.supports_affineview(CropSize) === true
        @test_throws MethodError Augmentor.applyaffineview(CropSize(1:2,2:3), nothing)
        @test @inferred(Augmentor.applyaffineview(CropSize(2,3), rect)) == view(Augmentor.prepareaffine(rect), IdentityRange(1:2), IdentityRange(1:3))
        @test @inferred(Augmentor.applyaffineview(CropSize(2,2), square2)) == view(Augmentor.prepareaffine(square2), IdentityRange(2:3), IdentityRange(2:3))
    end
    @testset "lazy" begin
        @test Augmentor.supports_lazy(CropSize) === true
        @test @inferred(Augmentor.applylazy(CropSize(2,3), rect)) === view(rect, IdentityRange(1:2), IdentityRange(1:3))
        @test @inferred(Augmentor.applylazy(CropSize(2,2), square2)) === view(square2, IdentityRange(2:3), IdentityRange(2:3))
    end
    @testset "view" begin
        @test Augmentor.supports_view(CropSize) === true
        @test @inferred(Augmentor.applyview(CropSize(2,3), rect)) === view(rect, IdentityRange(1:2), IdentityRange(1:3))
        @test @inferred(Augmentor.applyview(CropSize(2,2), square2)) === view(square2, IdentityRange(2:3), IdentityRange(2:3))
    end
    @testset "stepview" begin
        @test Augmentor.supports_stepview(CropSize) === true
        @test @inferred(Augmentor.applystepview(CropSize(2,3), rect)) === view(rect, 1:1:2, 1:1:3)
        @test @inferred(Augmentor.applystepview(CropSize(2,2), square2)) === view(square2, 2:1:3, 2:1:3)
    end
    @testset "permute" begin
        @test Augmentor.supports_permute(CropSize) === false
    end
end

# --------------------------------------------------------------------

@testset "CropRatio" begin
    @test (CropRatio <: Augmentor.AffineOperation) == false
    @test typeof(@inferred(CropRatio())) <: CropRatio <: Augmentor.ImageOperation
    @testset "constructor" begin
        @test_throws MethodError CropRatio(())
        @test_throws MethodError CropRatio(1.,2.)
        @test_throws MethodError CropRatio(:a)
        @test_throws MethodError CropRatio([:a])
        @test_throws ArgumentError CropRatio(-1)
        @test_throws ArgumentError CropRatio(0)
        op = @inferred(CropRatio(3/4))
        @test op === CropRatio(ratio=3/4)
        @test str_show(op) == "Augmentor.CropRatio(0.75)"
        @test str_showconst(op) == "CropRatio(0.75)"
        @test str_showcompact(op) == "Crop to 3:4 aspect ratio"
        op = @inferred(CropRatio(1))
        @test op === @inferred(CropRatio())
        @test op === CropRatio(ratio=1)
        @test str_show(op) == "Augmentor.CropRatio(1.0)"
        @test str_showconst(op) == "CropRatio(1.0)"
        @test str_showcompact(op) == "Crop to 1:1 aspect ratio"
        op = @inferred(CropRatio(2.5))
        @test op === CropRatio(ratio=2.5)
        @test str_show(op) == "Augmentor.CropRatio(2.5)"
        @test str_showconst(op) == "CropRatio(2.5)"
        @test str_showcompact(op) == "Crop to 5:2 aspect ratio"
        op = @inferred(CropRatio(sqrt(2)))
        @test str_showcompact(op) == "Crop to 1.41 aspect ratio"
    end
    @testset "eager" begin
        @test_throws MethodError Augmentor.applyeager(CropRatio(10), nothing)
        @test_throws MethodError Augmentor.applyeager(CropRatio(2), nothing)
        @test Augmentor.supports_eager(CropRatio) === false
        for img in (rect, OffsetArray(rect, -2, -1), view(rect, IdentityRange(1:2), IdentityRange(1:3)))
            @test @inferred(Augmentor.applyeager(CropRatio(3/2), img)) == rect
            @test typeof(Augmentor.applyeager(CropRatio(3/2), img)) <: Array
        end
        @test @inferred(Augmentor.applyeager(CropRatio(1), rect)) == rect[1:2,1:2]
        @test @inferred(Augmentor.applyeager(CropRatio(1), square)) == square
        @test @inferred(Augmentor.applyeager(CropRatio(1), square2)) == square2
    end
    @testset "affine" begin
        @test Augmentor.supports_affine(CropRatio) === false
    end
    @testset "affineview" begin
        @test Augmentor.supports_affineview(CropRatio) === true
        @test_throws MethodError Augmentor.applyaffineview(CropRatio(1), nothing)
        @test @inferred(Augmentor.applyaffineview(CropRatio(1), rect)) == view(Augmentor.prepareaffine(rect), IdentityRange(1:2), IdentityRange(1:2))
        @test @inferred(Augmentor.applyaffineview(CropRatio(2), square2)) == view(Augmentor.prepareaffine(square2), IdentityRange(2:3), IdentityRange(1:4))
        @test @inferred(Augmentor.applyaffineview(CropRatio(.5), square2)) == view(Augmentor.prepareaffine(square2), IdentityRange(1:4), IdentityRange(2:3))
    end
    @testset "lazy" begin
        @test Augmentor.supports_lazy(CropRatio) === true
        @test @inferred(Augmentor.applylazy(CropRatio(1), rect)) === view(rect, IdentityRange(1:2), IdentityRange(1:2))
        @test @inferred(Augmentor.applylazy(CropRatio(2), square2)) === view(square2, IdentityRange(2:3), IdentityRange(1:4))
        @test @inferred(Augmentor.applylazy(CropRatio(.5), square2)) === view(square2, IdentityRange(1:4), IdentityRange(2:3))
    end
    @testset "view" begin
        @test Augmentor.supports_view(CropRatio) === true
        @test @inferred(Augmentor.applyview(CropRatio(1), rect)) === view(rect, IdentityRange(1:2), IdentityRange(1:2))
        @test @inferred(Augmentor.applyview(CropRatio(2), square2)) === view(square2, IdentityRange(2:3), IdentityRange(1:4))
        @test @inferred(Augmentor.applyview(CropRatio(.5), square2)) === view(square2, IdentityRange(1:4), IdentityRange(2:3))
    end
    @testset "stepview" begin
        @test Augmentor.supports_stepview(CropRatio) === true
        @test @inferred(Augmentor.applystepview(CropRatio(1), rect)) === view(rect, 1:1:2, 1:1:2)
        @test @inferred(Augmentor.applystepview(CropRatio(2), square2)) === view(square2, 2:1:3, 1:1:4)
        @test @inferred(Augmentor.applystepview(CropRatio(.5), square2)) === view(square2, 1:1:4, 2:1:3)
    end
    @testset "permute" begin
        @test Augmentor.supports_permute(CropRatio) === false
    end
end

# --------------------------------------------------------------------

@testset "RCropRatio" begin
    @test (RCropRatio <: Augmentor.AffineOperation) == false
    @test typeof(@inferred(RCropRatio())) <: RCropRatio <: Augmentor.ImageOperation
    @testset "constructor" begin
        @test_throws MethodError RCropRatio(())
        @test_throws MethodError RCropRatio(1.,2.)
        @test_throws MethodError RCropRatio(:a)
        @test_throws MethodError RCropRatio([:a])
        @test_throws ArgumentError RCropRatio(-1)
        @test_throws ArgumentError RCropRatio(0)
        op = @inferred(RCropRatio(3/4))
        @test op === RCropRatio(ratio=3/4)
        @test str_show(op) == "Augmentor.RCropRatio(0.75)"
        @test str_showconst(op) == "RCropRatio(0.75)"
        @test str_showcompact(op) == "Crop random window with 3:4 aspect ratio"
        op = @inferred(RCropRatio(1))
        @test op === @inferred(RCropRatio())
        @test op === RCropRatio(ratio=1)
        @test str_show(op) == "Augmentor.RCropRatio(1.0)"
        @test str_showconst(op) == "RCropRatio(1.0)"
        @test str_showcompact(op) == "Crop random window with 1:1 aspect ratio"
        op = @inferred(RCropRatio(2.5))
        @test op === RCropRatio(ratio=2.5)
        @test str_show(op) == "Augmentor.RCropRatio(2.5)"
        @test str_showconst(op) == "RCropRatio(2.5)"
        @test str_showcompact(op) == "Crop random window with 5:2 aspect ratio"
        op = @inferred(RCropRatio(sqrt(2)))
        @test str_showcompact(op) == "Crop random window with 1.41 aspect ratio"
    end
    @testset "eager" begin
        @test_throws MethodError Augmentor.applyeager(RCropRatio(10), nothing)
        @test_throws MethodError Augmentor.applyeager(RCropRatio(2), nothing)
        @test Augmentor.supports_eager(RCropRatio) === false
        for img in (rect, OffsetArray(rect, -2, -1), view(rect, IdentityRange(1:2), IdentityRange(1:3)))
            @test @inferred(Augmentor.applyeager(RCropRatio(3/2), img)) == rect
            @test typeof(Augmentor.applyeager(RCropRatio(3/2), img)) <: Array
        end
        @test @inferred(Augmentor.applyeager(RCropRatio(1), square)) == square
        @test @inferred(Augmentor.applyeager(RCropRatio(1), square2)) == square2
        out = @inferred Augmentor.applyeager(RCropRatio(1), rect)
        @test out == rect[1:2,1:2] || out == rect[1:2,2:3]
    end
    @testset "affine" begin
        @test Augmentor.supports_affine(RCropRatio) === false
    end
    @testset "affineview" begin
        @test Augmentor.supports_affineview(RCropRatio) === true
        @test_throws MethodError Augmentor.applyaffineview(RCropRatio(1), nothing)
        # preserve aspect ratio (i.e. not random)
        @test @inferred(Augmentor.applyaffineview(RCropRatio(3/2), rect)) == view(Augmentor.prepareaffine(rect), IdentityRange(1:2), IdentityRange(1:3))
        @test @inferred(Augmentor.applyaffineview(RCropRatio(1), square)) == view(Augmentor.prepareaffine(square), IdentityRange(1:3), IdentityRange(1:3))
        @test @inferred(Augmentor.applyaffineview(RCropRatio(1), square2)) == view(Augmentor.prepareaffine(square2), IdentityRange(1:4), IdentityRange(1:4))
        # randomly placed
        out = @inferred Augmentor.applyaffineview(RCropRatio(1), rect)
        @test out == view(Augmentor.prepareaffine(rect), IdentityRange(1:2), IdentityRange(1:2)) || out == view(Augmentor.prepareaffine(rect), IdentityRange(1:2), IdentityRange(2:3))
        out = @inferred Augmentor.applyaffineview(RCropRatio(2/3), square)
        @test out == view(Augmentor.prepareaffine(square), IdentityRange(1:3), IdentityRange(1:2)) || out == view(Augmentor.prepareaffine(square), IdentityRange(1:3), IdentityRange(2:3))
        out = @inferred Augmentor.applyaffineview(RCropRatio(3/2), square)
        @test out == view(Augmentor.prepareaffine(square), IdentityRange(1:2), IdentityRange(1:3)) || out == view(Augmentor.prepareaffine(square), IdentityRange(2:3), IdentityRange(1:3))
    end
    @testset "lazy" begin
        @test Augmentor.supports_lazy(RCropRatio) === true
        # preserve aspect ratio (i.e. not random)
        @test @inferred(Augmentor.applylazy(RCropRatio(3/2), rect)) === view(rect, IdentityRange(1:2), IdentityRange(1:3))
        @test @inferred(Augmentor.applylazy(RCropRatio(1), square)) === view(square, IdentityRange(1:3), IdentityRange(1:3))
        @test @inferred(Augmentor.applylazy(RCropRatio(1), square2)) === view(square2, IdentityRange(1:4), IdentityRange(1:4))
        # randomly placed
        out = @inferred Augmentor.applylazy(RCropRatio(1), rect)
        @test out === view(rect, IdentityRange(1:2), IdentityRange(1:2)) || out === view(rect, IdentityRange(1:2), IdentityRange(2:3))
        out = @inferred Augmentor.applylazy(RCropRatio(2/3), square)
        @test out === view(square, IdentityRange(1:3), IdentityRange(1:2)) || out === view(square, IdentityRange(1:3), IdentityRange(2:3))
        out = @inferred Augmentor.applylazy(RCropRatio(3/2), square)
        @test out === view(square, IdentityRange(1:2), IdentityRange(1:3)) || out === view(square, IdentityRange(2:3), IdentityRange(1:3))
    end
    @testset "view" begin
        @test Augmentor.supports_view(RCropRatio) === true
        # preserve aspect ratio (i.e. not random)
        @test @inferred(Augmentor.applyview(RCropRatio(3/2), rect)) === view(rect, IdentityRange(1:2), IdentityRange(1:3))
        @test @inferred(Augmentor.applyview(RCropRatio(1), square)) === view(square, IdentityRange(1:3), IdentityRange(1:3))
        @test @inferred(Augmentor.applyview(RCropRatio(1), square2)) === view(square2, IdentityRange(1:4), IdentityRange(1:4))
        # randomly placed
        out = @inferred Augmentor.applyview(RCropRatio(1), rect)
        @test out === view(rect, IdentityRange(1:2), IdentityRange(1:2)) || out === view(rect, IdentityRange(1:2), IdentityRange(2:3))
        out = @inferred Augmentor.applyview(RCropRatio(2/3), square)
        @test out === view(square, IdentityRange(1:3), IdentityRange(1:2)) || out === view(square, IdentityRange(1:3), IdentityRange(2:3))
        out = @inferred Augmentor.applyview(RCropRatio(3/2), square)
        @test out === view(square, IdentityRange(1:2), IdentityRange(1:3)) || out === view(square, IdentityRange(2:3), IdentityRange(1:3))
    end
    @testset "stepview" begin
        @test Augmentor.supports_stepview(RCropRatio) === true
        # preserve aspect ratio (i.e. not random)
        @test @inferred(Augmentor.applystepview(RCropRatio(3/2), rect)) === view(rect, 1:1:2, 1:1:3)
        @test @inferred(Augmentor.applystepview(RCropRatio(1), square)) === view(square, 1:1:3, 1:1:3)
        @test @inferred(Augmentor.applystepview(RCropRatio(1), square2)) === view(square2, 1:1:4, 1:1:4)
        # randomly placed
        out = @inferred Augmentor.applystepview(RCropRatio(1), rect)
        @test out === view(rect, 1:1:2, 1:1:2) || out === view(rect, 1:1:2, 2:1:3)
        out = @inferred Augmentor.applystepview(RCropRatio(2/3), square)
        @test out === view(square, 1:1:3, 1:1:2) || out === view(square, 1:1:3, 2:1:3)
        out = @inferred Augmentor.applystepview(RCropRatio(3/2), square)
        @test out === view(square, 1:1:2, 1:1:3) || out === view(square, 2:1:3, 1:1:3)
    end
    @testset "permute" begin
        @test @inferred(Augmentor.supports_permute(RCropRatio)) === false
    end
end
