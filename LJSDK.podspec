
Pod::Spec.new do |spec|
# 名称 和要文件或github中的工程名保持一致
spec.name         = "LJSDK"
# 版本号，要与 git tag 保持一致，每次提交要递增 
spec.version      = "0.0.1"
# 简介要写一段文字
spec.summary      = "lejunsdk项目包"
# 详细描述的言语字要多写一点，文字只能在DESC中间
spec.description  = <<-DESC
    lejunsdk
                   DESC
                   
#  项目主页 在github上创建的工程
spec.homepage     = "https://github.com/out-mj27/talk-mj27.git"
# 协议 MIT, 前面创建工程提到的创建github工程的协议
spec.license      = "MIT"

# 作者，这个不要动，创建时会自动生成
spec.author             = { "lejun2020" => "kison@bibinow.com" }

# 指定运行平台，iOS 9.0以上
spec.platform     = :ios, "13.0"

# 源代码位置 git里与hoepage保持一致就可以了, tag不要动，会自动获取变量
spec.source       = { :git => "https://github.com/out-mj27/talk-mj27.git", :tag => "#{spec.version}" }

# SDK头文件路径(可以不写)
# spec.public_header_files = "HYManager-Swift/HYManagerSDK.framework/Headers/HYManagerSDK.h"

# 开放的头文件，从工程根目录下开始写起
spec.source_files  = "LJSDK.framework/**/*"

# 排除文件
# spec.exclude_files = "Example"

# SDK的路径 写上库的位置 (自动生成没有这一项，可以不写试一下)
#spec.vendored_frameworks = "talk-mj27/LJSDK.framework"

# 依赖系统的一些库，有就写，没有就不要写 
# framework, frameworks：一个库就是用framework,多个库设置frameworks并使用,分割。
# library, libraries：同上，需要注意的是设置lib依赖库时，省略其名称的lib前缀，以及.后缀。如 spec.library   = "iconv"
spec.frameworks = "Foundation"

# 第三方依赖 有几个就写几个，我这里没有使用过
# spec.dependency "JSONKit", "~> 1.4"

# 项目配置，注意这里的SDK不支持模拟器
# 如果多个字段就用逗号分开 { "VALID_ARCHS" => "x86_64 armv7 arm64", "ENABLE_BITCODE" => "NO" }
spec.pod_target_xcconfig = { "VALID_ARCHS" => "armv7 arm64" }
end
