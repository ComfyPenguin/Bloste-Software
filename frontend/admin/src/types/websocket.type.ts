export interface WebSocketMessageData {
  error?: string
  status?: string
  timestamp: string
  videoId?: string
  metadata?: VideoMetadata
}

export interface WebSocketMessage {
  event: 'videoProcessed' | 'videoFailed' | 'statusUpdate'
  data: WebSocketMessageData
}

export interface VideoMetadata {
  id?: string
  videoId?: string
  thumbnailPath: string
  hlsPath: string
  duration: number
}
