class_name ScreenData

var latest_screen: String

static  func buide() -> ScreenData:
	return ScreenData.new()

func last_screen(current_screen: String) -> ScreenData:
	latest_screen = current_screen
	return self
