public enum QRFormat: String
{
    case PNG
    case EPS
    case SVG
    case ANSI
    case ANSI256
    case ASCII
    case ASCIIi
    case UTF8
    case ANSIUTF8
}

public enum QRSize: String
{
    case small = "3"
    case medium = "10"
    case large = "20"
    case xlarge = "50"
    case xxlarge = "100"
}

public class QREncode {
 
    let text: String
    let fileName: String
    let size: QRSize
    let launchPath: String
    let format: QRFormat
    /// A list of extra arguments which will be send to qrencode directly
    ///
    ///
    /// Examples: `["--margin","<margin>", "--casesensitive"]`
    let qrArgs: [String]
    

    public init(text: String,fileName: String, size: QRSize = .medium ,format: QRFormat = .PNG, path: String = "/usr/bin/qrencode", qrArgs: [String] = []) {
        self.text = text
        self.fileName = fileName
        self.size = size
        self.format = format
        self.launchPath = path
        self.qrArgs = qrArgs
    }
}
