import { pasteboard } from '@kit.BasicServicesKit';

export class FeedbackService {
  static async copyToClipboard(text: string): Promise<boolean> {
    try {
      const data = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, text);
      const sys = pasteboard.getSystemPasteboard();
      await sys.setData(data);
      return true;
    } catch (_e) {
      return false;
    }
  }
}
