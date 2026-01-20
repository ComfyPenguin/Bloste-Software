<script setup lang="ts">
import { ref } from 'vue'
import FileUploader from '@/components/FileUploader/FileUploader.vue'
import UploadForm from '@/components/UploadForm/UploadForm.vue'

const suggestedTitle = ref('')
const onFileSelected = (title: string) => {
  suggestedTitle.value = title
}
</script>

<template>
  <main class="upload-view">
    <div class="upload-grid">
      <aside class="uploader-col">
        <FileUploader @file-selected="onFileSelected" />
      </aside>

      <section class="form-col">
        <UploadForm :suggested-title="suggestedTitle" />
      </section>
    </div>
  </main>
</template>

<style scoped>
.upload-view {
  padding: 1.25rem;
  min-height: 100vh;
  box-sizing: border-box;
}
.upload-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(360px, 1fr));
  gap: 1.5rem;
  align-items: start;
  width: 100%;
  max-width: 1600px;
  margin: 0 auto;
}
.uploader-col,
.form-col {
  width: 100%;
  min-width: 0; /* prevent overflow */
}

/* Ensure child components fill their column width */
.upload-grid > .form-col > .upload-form,
.upload-grid > .uploader-col > .uploader {
  width: 100%;
  max-width: 100%;
  margin: 0;
  box-sizing: border-box;
}

@media (max-width: 768px) {
  .upload-view {
    padding: 1rem;
  }
  .upload-grid {
    grid-template-columns: 1fr;
    gap: 1rem;
  }
  .uploader-col {
    order: 0;
  }
  .form-col {
    order: 1;
  }
}

@media (max-width: 480px) {
  .upload-view {
    padding: 0.75rem;
  }
  .upload-grid {
    gap: 0.75rem;
  }
}
</style>
