import SwiftUI
@preconcurrency import WebKit

struct WebView: NSViewRepresentable {
    var urlString: String
    private var url: URL
    let webView: WKWebView
    let scriptContent = """
            document.addEventListener('mousemove', function(e) {
                const edgeThreshold = 20;
                const cornerThreshold = 30;
                const windowWidth = window.innerWidth;
                const windowHeight = window.innerHeight;

                const nearLeftEdge = e.clientX < edgeThreshold;
                const nearBottomEdge = e.clientY > windowHeight - edgeThreshold;
                const inBottomLeftCorner = e.clientX < cornerThreshold && e.clientY > windowHeight - cornerThreshold;

                if (inBottomLeftCorner) {
                    document.body.style.cursor = 'all-scroll';
                } else if (nearLeftEdge) {
                    document.body.style.cursor = 'ew-resize';
                } else if (nearBottomEdge) {
                    document.body.style.cursor = 'ns-resize';
                } else {
                    document.body.style.cursor = 'default';
                }
            });
            """
    
    init(_ urlString: String, webView: WKWebView) {
        self.urlString = urlString
        self.url = URL(string: "https://\(urlString)") ?? URL(string: "about:blank")!
        self.webView = webView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeNSView(context: Context) -> WKWebView {
        webView.allowsBackForwardNavigationGestures = true
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        nsView.load(request)
    }
    
    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate, WKDownloadDelegate {
        
        var parent: WebView
        var popup: PopupManager
        
        init(_ parent: WebView) {
            self.parent = parent
            self.popup = PopupManager.shared
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
                // Execute the JavaScript
                webView.evaluateJavaScript(parent.scriptContent) { result, error in
                    if let error = error {
                        print("JavaScript execution error: \(error.localizedDescription)")
                    }
                }
            }
        
        func webView(_ webView: WKWebView, runOpenPanelWith parameters: WKOpenPanelParameters, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping ([URL]?) -> Void) {
            let panel = NSOpenPanel()
            panel.canChooseFiles = true
            panel.allowsMultipleSelection = true
            panel.canChooseDirectories = true
            
            DispatchQueue.main.async {
                if panel.runModal() == .OK {
                    completionHandler(panel.urls)
                    self.popup.refreshPopup()
                } else {
                    completionHandler(nil)
                    self.popup.refreshPopup()
                }
                
            }
            
            for window in NSApplication.shared.windows {
                if window.title != "Item-0" {
                    window.level = .floating
                }
            }
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
            if navigationAction.shouldPerformDownload {
                decisionHandler(.download, preferences)
            } else {
                decisionHandler(.allow, preferences)
            }
        }
        
        // this handles target=_blank links by opening them in the same view
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            if navigationResponse.canShowMIMEType {
                decisionHandler(.allow)
            } else {
                decisionHandler(.download)
            }
        }
        
        func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
            download.delegate = self // your `WKDownloadDelegate`
        }
        
        func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
            download.delegate = self // your `WKDownloadDelegate`
        }
        
        func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
            let savePanel = NSSavePanel()
            savePanel.canCreateDirectories = true
            savePanel.showsTagField = false
            savePanel.nameFieldStringValue = suggestedFilename
            savePanel.level = .screenSaver
            DispatchQueue.main.async {
                savePanel.begin { result in
                    if result == .OK {
                        completionHandler(savePanel.url)
                        self.popup.refreshPopup()
                    } else {
                        completionHandler(nil)
                        self.popup.refreshPopup()
                    }
                }
            }
        }
    }
}
